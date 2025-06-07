#!/bin/env ruby

# The base Paradise vessel, container of all things
# TODO: make thread-safe
class Teapot

  include Vessel

  attr_accessor :memory_index, :perm, :name, :note, :attr, :unde, :owner,
                :content, :is_locked, :is_hidden, :is_silent, :is_tunnel, :is_paradox

  attr_writer :program

  def initialize(content, memory_index)

    super(memory_index)

    @memory_index = memory_index

    @content = content

    @name = @content['NAME'] || 'nullspace'
    @attr = @content['ATTR'] || ''
    @note = @content['NOTE'] || ''

    code  = @content['CODE'].nil? ? nil : @content['CODE'].split('-')
    @perm = code ? code[0]      : '1111'
    @unde = code ? code[1].to_i : 1
    @owner = code ? code[2].to_i : 0
    @time = code ? code[3] : Timestamp.new

    @is_locked  = @perm[0, 1].to_i == 1
    @is_hidden  = @perm[1, 1].to_i == 1
    @is_silent  = @perm[2, 1].to_i == 1
    @is_tunnel  = @perm[3, 1].to_i == 1
    @is_paradox = memory_index == @unde

    @path = File.expand_path(File.join(File.dirname(__FILE__), '/'))
    @docs = 'Default Paradise vessel.'

    install(:information, :look)
    install(:information, :actions)
    install(:information, :inspect)

    install(:basic, :create)
    install(:basic, :become)
    install(:basic, :enter)
    install(:basic, :leave)

    install(:movement, :warp)
    install(:movement, :take)
    install(:movement, :drop)

    install(:communication, :say)
    install(:communication, :emote)
    install(:communication, :signal)

    install(:narrative, :note)
    install(:narrative, :transform)
    install(:narrative, :set)

    install(:automation, :program)
    install(:automation, :use)
    install(:automation, :cast)

    all_actions = actions.values
                         .reduce([]) { |combined_arr, arr| combined_arr.concat(arr) }

    @actions_by_name = all_actions.each_with_object({}) do |action, actions_by_name|

      actions_by_name[action.name.downcase.to_sym] = action

    end

  end

  def act(action_name, params = nil)

    # TODO: return which character(s) were unallowed
    # TODO: see if this list can be made shorter (why are these unallowed?)
    unless params.match(/\A[a-zA-Z0-9 \-_)(.,+?!)]*\z/)
      return "<h3>#{action_name} Failure</h3><p>This command contained unallowed characters.</p>"
    end

    # All the installed actions are in a list on the vessel, organized by category.
    # See if the action name matches the name of one of these actions.
    # Note: if an action has the same name for a strange reason as another,
    # the first will be used. Best not to create actions with the same name.
    action = @actions_by_name[action_name.to_sym] || nil

    return answer(ActionLook.new, :error, "\"#{action_name.capitalize}\" is not a valid action.") if action.nil?

    action.act(params)

  end

  def answer(action, type, message, etc = nil)

    if type == :error
      return "<h3>#{action.verb} Failed</h3><p>#{message}</p><p class='small'>#{etc || 'Press <b>enter</b> to continue.'}</p>"
    end

    "<h3>#{action.verb}...</h3><p>#{message}</p><p class='small'>#{etc || 'Press <b>enter</b> to continue.'}</p>"

  end

  def to_html(action_override = nil, class_override = nil)

    attr        = has_attr ? "#{@attr} " : ''
    name        = @name.to_s
    action      = has_program ? "use the #{attr}#{name}" : "enter the #{attr}#{name}"
    action      = action_override || action
    action_tags = "data-name='#{@name}' data-attr='#{@attr}' data-action='#{action}'"

    "<vessel-link class='#{attr}#{class_override || classes}' #{action_tags}>#{attr}<name>#{name}</name></vessel-link>"

  end

  def to_s

    "#{has_attr ? "#{@attr} " : ''}#{@name}"

  end

  def classes

    html = ''
    html += "program #{program.type}" if has_program
    html += 'stem ' if is_paradox
    html.strip

  end

  def encode

    code = ''
    code += @is_locked == true ? '1' : '0'
    code += @is_hidden == true ? '1' : '0'
    code += @is_silent == true ? '1' : '0'
    code += @is_tunnel == true ? '1' : '0'

    unde = @unde.to_s.prepend('0', 5)
    owner = @owner.to_s.prepend('0', 5)
    name = @name.to_s.append(' ', 14)
    attr = @attr.to_s.append(' ', 14)
    p = program.to_s.append(' ', 61)

    "#{code}-#{unde}-#{owner}-#{Timestamp.new} #{name} #{attr} #{p} #{@note}".strip

  end

  def save

    $nataniev.vessels[:paradise].paradise.update(@memory_index, encode)

    true

  end

  def reset_siblings
    @siblings = nil
  end

  def reset_children
    @children = nil
  end

  def reset_parent
    @parent = nil
  end

  def reload

    reset_siblings
    reset_children
    reset_parent

  end

  def parent

    await_parade

    @parent ||= $nataniev.vessels[:paradise].parade[@unde]

    if @parent
      (@parent.memory_index = @unde
       @parent)
    else
      VesselVoid.new
    end

  end

  def stem

    return @stem if @stem

    @depth = 0
    @stem = self

    while @depth < 50
      @stem = stem.parent
      return @stem if @stem.memory_index == @stem.parent.memory_index

      @depth += 1
    end

    puts 'Too deep to find stem...'

    @stem

  end

  def depth

    @depth = 0

    @stem = parent

    while @depth < 50
      @stem = stem.parent
      return @depth + 1 if @stem.memory_index == @stem.parent.memory_index

      @depth += 1
    end

    @depth + 1

  end

  def program

    Program.new(self, @content['PROGRAM'])

  end

  def creator

    @creator ||= $nataniev.vessels[:paradise].parade[owner]

    @creator || VesselVoid.new

  end

  def siblings

    return @siblings if @siblings

    await_parade

    @siblings = []
    $nataniev.vessels[:paradise].parade.each do |vessel|

      next if vessel.unde != @unde
      next if vessel.parent && vessel.memory_index == parent.memory_index
      next if vessel.memory_index == @memory_index
      next if parent.is_silent && vessel.owner != parent.owner && vessel.owner != memory_index

      @siblings.push(vessel)

    end
    @siblings

  end

  def children

    return @children if @children
    return [] unless $nataniev.vessels[:paradise].parade

    @children = []
    $nataniev.vessels[:paradise].parade.each do |vessel|

      next if vessel.unde != @memory_index
      next if vessel.memory_index == @memory_index
      next if is_silent && vessel.owner != owner && vessel.owner != @memory_index

      @children.push(vessel)

    end
    @children

  end

  def find_distant(params)

    parts = params.remove_articles.split(' ')

    vessel_id = parts.last.to_i
    parade_vessel = $nataniev.vessels[:paradise].parade[vessel_id]

    # A vessel_id of 0 means that there was no number found
    # in the final part of the param array, and thus not a vessel_id
    return parade_vessel if vessel_id.positive? && parade_vessel

    name = parts[-1, 1]
    attr = parts.length > 1 ? parts[-2, 1] : nil

    # Precise
    $nataniev.vessels[:paradise].parade.each do |vessel|

      return vessel if vessel.name.like(name) && (attr && vessel.attr.like(attr))

    end

    # Flexible
    $nataniev.vessels[:paradise].parade.shuffle.each do |vessel|

      return vessel if vessel.name.like(name)

    end

    nil

  end

  def find_visible(name)

    parts = name.remove_articles.split(' ')

    name = parts[-1, 1]
    attr = parts.length > 1 ? parts[-2, 1] : nil

    # Precise
    (siblings + children + [parent, self]).each do |vessel|

      return vessel if vessel.name.like(name) && vessel.attr.like(attr)

    end

    # Flexible
    (siblings + children + [parent, self]).each do |vessel|

      return vessel if vessel.name.like(name)

    end

    nil

  end

  def find_child(name)

    parts = name.remove_articles.split(' ')

    name = parts[-1, 1]
    attr = parts.length > 1 ? parts[-2, 1] : nil

    # Precise
    children.each do |vessel|

      return vessel if vessel.name.like(name) && vessel.attr.like(attr)

    end

    # Flexible
    children.each do |vessel|

      return vessel if vessel.name.like(name)

    end

    nil

  end

  def find_random

    candidates = []
    $nataniev.vessels[:paradise].parade.each do |vessel|

      next if vessel.is_hidden

      candidates.push(vessel)

    end

    candidates[Time.new.to_i * 579 % candidates.length]

  end

  # Setters

  def set_note(val)

    @note = val
    save
    reload

  end

  def set_unde(val)

    @unde = val.to_i > 99_999 ? 99_999 : val.to_i
    save
    reload

  end

  def set_program(val)

    @content['PROGRAM'] = val
    save
    reload

  end

  def set_name(val)

    @name = val
    save
    reload

  end

  def set_attr(val)

    @attr = val
    save
    reload

  end

  def set_locked(val)

    @is_locked = val
    save
    reload

  end

  def set_hidden(val)

    @is_hidden = val
    save
    reload

  end

  def set_silent(val)

    @is_silent = val
    save
    reload

  end

  def set_tunnel(val)

    @is_tunnel = val
    save
    reload

  end

  # Testers

  def has_note

    @note.to_s.strip != ''

  end

  def has_attr

    @attr.to_s != ''

  end

  def has_program

    program.is_valid

  end

  def has_children

    !children.empty?

  end

  def is_paradox

    return true if memory_index == unde

    false

  end

  def is_unique

    $nataniev.vessels[:paradise].parade.each do |vessel|

      next if vessel.memory_index == @memory_index
      return false if vessel.name.like(@name) && vessel.attr.like(@attr)

    end
    true

  end

  def is_valid

    errors = []

    errors.push('The vessel name cannot be blank.') if name.to_s.strip == ''
    errors.push('The vessel name cannot be more than 14 characters long.') if name.length > 14
    errors.push('The vessel name cannot be less than 3 characters long.') if name.length < 3
    errors.push("Please do not use the word #{name.has_badword} in Paradise.") if name.has_badword
    errors.push('Vessel names can only contain letters.') if name.is_alphabetic == false

    if has_attr
      errors.push('The vessel attribute cannot be more than 14 characters long.') if attr.length > 14
      errors.push('The vessel attribute cannot be less than 3 characters long.') if attr.length < 3
      errors.push("Please do not use the word #{attr.has_badword} in Paradise.") if attr.has_badword
      errors.push('Vessel attributes can only contain letters.') if attr.is_alphabetic == false
      errors.push('Vessels cannot have the same attribute and name.') if name == attr
    end

    [!errors.empty?, errors]

  end

  def guides

    hints = []

    # Statuses
    hints.push("The #{name} is locked, you may not modify it.") if is_locked
    hints.push("The #{name} is hidden, you may not see its warp id.") if is_hidden
    hints.push("The #{name} is silent, you may not see other's vessels.") if is_silent
    hints.push("The #{name} is a tunnel.") if is_tunnel
    hints.push("The #{name} is a paradox, you may not leave.") if is_paradox
    hints.push('You are in the lobby. Additional forum messages are visible here.') if name.like('lobby')

    # Check Validity
    validity_check, validity_errors = is_valid
    hints += validity_errors if validity_check == false
    validity_check, validity_errors = is_valid
    hints += validity_errors if validity_check == false

    # Improvements
    unless is_locked
      unless has_program
        hints.push("Automate this vessel with a <action-link data-action='program '>program</action-link>.")
      end
      unless has_note
        hints.push("Improve this vessel with a <action-link data-action='note '>description</action-link>.")
      end
    end

    hints.push("You own this #{name}.") if owner == $player_id

    hints

  end

  def rating

    sum = 0

    values = [
      has_note,
      has_attr,
      has_program,
      has_children,
      is_paradox,
      is_locked,
      is_hidden,
      is_silent,
      is_tunnel
    ]

    values.each do |val|

      sum += val ? 1 : 0

    end

    ((sum / values.length.to_f) * 100).to_i

  end

  def await_parade

    # Sometimes corpse and parade are nil (wut?)
    # My working theory is that as other http requests hit invoke.rb, the
    # corpse and parade variables are getting reassigned and when this tries
    # to access them while they are being reassigned, nil is returned.
    # Waiting a bit if they are nil seems to fix the bug...
    it = 0
    while it < 10 && (defined?($nataniev.vessels[:paradise].corpse).nil? || $nataniev.vessels[:paradise].corpse.nil?)
      puts 'Searching for corpse...'
      sleep 0.5
      it += 1
    end

    it = 0
    while it < 10 && (defined?($nataniev.vessels[:paradise].parade).nil? || $nataniev.vessels[:paradise].parade.nil?)
      puts 'Searching for parade...'
      sleep 0.5
      it += 1
    end

    nil

  end

end
