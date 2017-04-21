#!/bin/env ruby
# encoding: utf-8

class Ghost

  include Vessel

  attr_accessor :id
  attr_accessor :name
  attr_accessor :note
  attr_accessor :attr
  attr_accessor :unde
  attr_accessor :owner
  attr_accessor :program

  attr_accessor :is_locked
  attr_accessor :is_hidden
  attr_accessor :is_quiet 
  attr_accessor :is_frozen

  def initialize content

    super

    @content = content

    @name = @content["NAME"] ? @content["NAME"] : "nullspace"
    @attr = @content["ATTR"] ? @content["ATTR"] : ""
    @note = @content["NOTE"] ? @content["NOTE"] : ""
    @perm  = @content["CODE"] ? @content["CODE"].split("-")[0] : "1111"
    @unde  = @content["CODE"] ? @content["CODE"].split("-")[1].to_i : 1
    @owner = @content["CODE"] ? @content["CODE"].split("-")[2].to_i : 0
    @time  = @content["CODE"] ? @content["CODE"].split("-")[3] : Timestamp.new

    # Code

    @is_locked = @perm[0,1].to_i == 1 ? true : false
    @is_hidden = @perm[1,1].to_i == 1 ? true : false
    @is_quiet  = @perm[2,1].to_i == 1 ? true : false
    @is_frozen = @perm[3,1].to_i == 1 ? true : false
    
    @program = @content["PROGRAM"]

    @path = File.expand_path(File.join(File.dirname(__FILE__), "/"))
    @docs = "Default Paradise vessel."
    
    install(:generic,:look)
    install(:generic,:help)

    install(:basic,:become)
    install(:basic,:leave)
    install(:basic,:enter)
    install(:basic,:create)

    install(:movement,:warp)

    install(:advanced,:take)
    install(:advanced,:drop)
    install(:advanced,:lock)
    install(:advanced,:unlock)

    install(:communication,:say)

    install(:narrative,:transmute)
    install(:narrative,:transform)
    install(:narrative,:describe)

    install(:programming,:program)
    install(:programming,:use)
    install(:programming,:inspect)

    install(:deconstruction,:destroy)

  end

  def to_s show_attr = true, show_particle = true, show_action = true

    particle = "a "
    if @note != "" || @attr != "" then particle = "the " end
    if @attr && @attr[0,1] == "a" then particle = "an " end
    if @attr.to_s == "" && @name[0,1] == "a" then particle = "an " end

    action_attributes = show_action == true ? "data-name='#{@name}' data-attr='#{@attr}' data-action='#{has_program ? 'use the '+@name : 'enter the '+@name}'" : ""

    return "<vessel class='#{classes}' #{action_attributes}>#{show_particle != false ? particle : ''} #{show_attr != false && @attr ? '<attr class='+@attr+'>'+@attr+'</attr> ' : ''}<name>#{@name}</name></vessel>"

  end

  def parent

    @parent = @parent ? @parent : $parade[@unde]

    return @parent ? (@parent.id = @unde ; @parent) : Void.new

  end

  def siblings

    if @siblings then return @siblings end

    @siblings = []
    $parade.each do |vessel|
      if vessel.unde == @unde && vessel.id != @id && vessel.id != @unde
        @siblings.push(vessel)
      end
    end
    return @siblings

  end

  def children

    if @children then return @children end

    @children = []
    $parade.each do |vessel|
      if vessel.unde != @id then next end
      if vessel.name == @name then next end
      @children.push(vessel)
    end
    return @children

  end

  def classes

    html = ""
    if has_program
      if program.split(" ").first.like("warp") then html += "warp "
      elsif program.split(" ").first.like("create") then html += "machine "
      elsif program.split(" ").first.like("say") then html += "speaker "
      else html += "program " end
    end
    if unde == id then html += "stem " end

    return html.strip

  end

  def to_debug

    return "#{@name}:#{@attr}(#{@id})"

  end

  def encode

    code = ""
    code += @is_locked == true ? "1" : "0"
    code += @is_hidden == true ? "1" : "0"
    code += @is_quiet  == true ? "1" : "0"
    code += @is_frozen == true ? "1" : "0"

    return "#{code}-#{@unde.to_s.prepend('0',5)}-#{@owner.to_s.prepend('0',5)}-#{Timestamp.new} #{@name.to_s.append(' ',14)} #{@attr.to_s.append(' ',14)} #{@program.to_s.append(' ',61)} #{@note}".strip

  end

  def save

    $paradise.overwrite_line(@id+4,encode)

    return true

  end

  def reload

    @siblings = nil
    @children = nil
    @parent = nil

  end

  def destroy

    $paradise.overwrite_line(@id+4,"")

  end

  def is_stem

    if id == @unde then return true end
    return nil

  end

  # Setters

  def set_note val

    @note = val
    save
    reload

  end

  def set_unde val

    @unde = val.to_i
    save
    reload

  end

  def set_program val

    @program = val
    save
    reload

  end

  def set_name val

    @name = val
    save
    reload

  end

  def set_attr val

    @attr = val
    save
    reload

  end

  def set_locked val

    @is_locked = val
    save
    reload

  end

  # Testers

  def has_note

    return @note.to_s != "" ? true : false
    
  end

  def has_attr

    return @attr.to_s != "" ? true : false
    
  end

  def has_program

    return @program.to_s != "" ? true : false
    
  end

  #

  def rank

    val = 0

    if has_note then val += 1 end
    if has_attr then val += 1 end
    if has_program then val += 1 end
    if is_locked then val += 1 end

    return val
    
  end

  def is_valid

    errors = []

    if name.to_s.strip == "" then errors.push("The vessel name cannot be blank.") end
    if name.length > 14 then errors.push("The vessel name cannot be more than 14 characters long.") end
    if name.length < 3 then errors.push("The vessel name cannot be less than 3 characters long.") end
    if name.has_badword then errors.push("Please do not use the word #{name.has_badword} in Paradise.") end
    if name.is_alphabetic == false then errors.push("Vessel names can only contain letters.") end

    if has_attr
      if attr.length > 14 then errors.push("The vessel attribute cannot be more than 14 characters long.") end
      if attr.length < 3 then errors.push("The vessel attribute cannot be less than 3 characters long.") end
      if attr.has_badword then errors.push("Please do not use the word #{attr.has_badword} in Paradise.") end
      if attr.is_alphabetic == false then errors.push("Vessel attributes can only contain letters.") end
      if name == attr then errors.push("Vessels cannot have the same attribute and name.") end
    end

    return errors.length > 0 ? false : true, errors

  end

end