#!/bin/env ruby
require_relative '_toolkit'

# Set attributes on vessels
class ActionSet

  include Action

  def initialize(q = nil)

    super

    @name = 'Set'
    @verb = 'Setting'
    @docs = 'Directly write attributes for a owned vessel, the set command is '\
            'meant to be used with programs and cast as spells.'
    @examples = ['<b>set</b> is_locked true <comment>You have locked the yard.</comment>']

  end

  # Set an attribute for the vessel via a spell
  def act(params = '')

    parts = params.split(' ')
    flags = %w[is_locked is_hidden is_silent is_tunnel]

    flag  = parts.first
    value = parts.last.to_sym

    player_id = $nataniev.vessels[:paradise].get_player_id

    only_one = "You may only set one attribute at a time, and you entered #{params}"
    al = "<action-link data-action='actions'>viewing the available actions</action-link>."
    help = "You can learn about the setting command by #{al}"
    return @host.answer(self, :error, only_one, help) if parts.length != 2
    return @host.answer(self, :error, "#{flag} is not a valid flag. ", help) unless flags.include?(flag)

    own_msg = "#{topic} do not own #{@host} and thus may not alter its attributes."
    own_help = "The 'set' command can only be used via a spell, and not directly. '\
               'Try casting a spell on a vessel you own."

    return @host.answer(self, :error, own_msg, own_help) if @host.owner != player_id

    return set_locked(value) if flag.like('is_locked')
    return set_hidden(value) if flag.like('is_hidden')
    return set_silent(value) if flag.like('is_silent')
    return set_tunnel(value) if flag.like('is_tunnel')

    @host.answer(self, :error, "Unknown attribute #{flag}.")

  end

  def set_locked(val)

    @host.set_locked(val == true)

    @host.answer(self, :modal, val == true ? "#{topic} locked #{@host}." : "#{topic} unlocked #{@host}.")

  end

  def set_hidden(val)

    return @host.answer(self, :error, "The #{@host.name} is locked.") if @host.is_locked

    @host.set_hidden(val == true)

    @host.answer(self, :modal, val == true ? "#{topic} concealed #{@host}." : "#{topic} revealed #{@host}.")

  end

  def set_silent(val)

    return @host.answer(self, :error, "The #{@host.name} is locked.") if @host.is_locked

    @host.set_silent(val == true)

    @host.answer(self, :modal, val == true ? "#{topic} silenced #{@host}." : "#{topic} unsilenced #{@host}.")

  end

  def set_tunnel(val)

    return @host.answer(self, :error, "The #{@host.name} is locked.") if @host.is_locked

    @host.set_tunnel(val == true)

    @host.answer(self, :modal, val == true ? "#{topic} tunneled #{@host}." : "#{topic} untunneled #{@host}.")

  end

end
