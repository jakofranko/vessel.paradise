#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionSet

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Set"
    @verb = "Setting"
    @docs = "Directly write attributes for the current active vessel."
    @examples = ["set parent 16\n<comment>You are now in the yard.</comment>"]

  end

  def act params = ""

    if params.split(" ").length != 2 then return @host.answer(self,:error,"#{topic} can learn about the setting command by typing <action data-action='help with narrative'>help with narrative</action>.") end

    flag = params.split(" ").first
    value = params.split(" ").last.to_sym

    if flag.like("is_locked") then return set_locked(value) end
    if flag.like("is_hidden") then return set_hidden(value) end
    if flag.like("is_silent") then return set_silent(value) end
    if flag.like("is_tunnel") then return set_tunnel(value) end

    return @host.answer(self,:error,"Unknown attribute #{flag}.")
    
  end

  def set_locked val

    if @host.owner != $player_id then return @host.answer(self,:error,"The #{@host.name} is not owned by #{topic.downcase}.") end

    @host.set_silent(val == :true ? true : false)

    return @host.answer(self,:modal,val == :true ? "#{topic} locked #{@host}." : "#{topic} unlocked #{@host}.")
    
  end

  def set_hidden val

    if @host.is_locked then return @host.answer(self,:error,"The #{@host.name} is locked.") end

    @host.set_silent(val == :true ? true : false)

    return @host.answer(self,:modal,val == :true ? "#{topic} concealed #{@host}." : "#{topic} revealed #{@host}.")
    
  end

  def set_silent val

    if @host.is_locked then return @host.answer(self,:error,"The #{@host.name} is locked.") end

    @host.set_silent(val == :true ? true : false)

    return @host.answer(self,:modal,val == :true ? "#{topic} silenced #{@host}." : "#{topic} unsilenced #{@host}.")
    
  end

  def set_tunnel val

    if @host.is_locked then return @host.answer(self,:error,"The #{@host.name} is locked.") end

    @host.set_silent(val == :true ? true : false)

    return @host.answer(self,:modal,val == :true ? "#{topic} tunneled #{@host}." : "#{topic} untunneled #{@host}.")
    
  end

end