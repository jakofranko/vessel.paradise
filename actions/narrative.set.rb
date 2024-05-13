#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionSet

  include Action

  def initialize q = nil

    super

    @name = "Set"
    @verb = "Setting"
    @docs = "Directly write attributes for a owned vessel, the set command is meant to be used with programs and casted as spells."
    @examples = ["<b>set</b> is_locked true <comment>You have locked the yard.</comment>"]

  end

  # Set an attribute for the vessel via a spell
  def act params = ""

    parts = params.split(" ")
    flags = ["is_locked","is_hidden","is_silent","is_tunnel"]

    flag  = parts.first
    value = parts.last.to_sym

    player_id = $nataniev.vessels[:paradise].get_player_id

    if parts.length != 2        then return @host.answer(self, :error, "You may only set one attribute at a time, and you entered #{params}", "You can learn about the setting command by <action-link data-action='actions'>viewing the available actions</action-link>.") end
    if !flags.include?(flag)    then return @host.answer(self, :error, "#{flag} is not a valid flag. ", "You can learn about the setting command by typing <action-link data-action='actions'>viewing the available actions</action-link>.") end
    if @host.owner != player_id then return @host.answer(self, :error, "#{topic} do not own #{@host} and thus may not alter its attributes.", "The 'set' command can only be used via a spell, and not directly. Try casting a spell on a vessel you own.") end

    if flag.like("is_locked") then return set_locked(value) end
    if flag.like("is_hidden") then return set_hidden(value) end
    if flag.like("is_silent") then return set_silent(value) end
    if flag.like("is_tunnel") then return set_tunnel(value) end

    return @host.answer(self, :error, "Unknown attribute #{flag}.")

  end

  def set_locked val

    @host.set_locked(val == :true ? true : false)

    return @host.answer(self, :modal, val == :true ? "#{topic} locked #{@host}." : "#{topic} unlocked #{@host}.")

  end

  def set_hidden val

    if @host.is_locked then return @host.answer(self, :error, "The #{@host.name} is locked.") end

    @host.set_hidden(val == :true ? true : false)

    return @host.answer(self, :modal, val == :true ? "#{topic} concealed #{@host}." : "#{topic} revealed #{@host}.")

  end

  def set_silent val

    if @host.is_locked then return @host.answer(self, :error, "The #{@host.name} is locked.") end

    @host.set_silent(val == :true ? true : false)

    return @host.answer(self, :modal, val == :true ? "#{topic} silenced #{@host}." : "#{topic} unsilenced #{@host}.")

  end

  def set_tunnel val

    if @host.is_locked then return @host.answer(self, :error, "The #{@host.name} is locked.") end

    @host.set_tunnel(val == :true ? true : false)

    return @host.answer(self, :modal, val == :true ? "#{topic} tunneled #{@host}." : "#{topic} untunneled #{@host}.")

  end

end
