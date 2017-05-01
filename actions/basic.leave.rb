#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionLeave

  include Action
  
  def initialize q = nil

    super

    @name = "Leave"
    @verb = "Leaving"
    @docs = "Exit the parent vessel."
    @examples = ["leave\n<comment>You are a black cat in the yard.</comment>"]

  end

  def act params = ""

    target = @host.parent.parent
    prev = @host.parent

    if @host.parent.is_paradox      then return @host.answer(self,:error,"#{topic} have reached the stem of the universe. The #{@host.parent.name} is a paradox and may not be exited. ") end
    if @host.is_locked == true      then return @host.answer(self,:error,"#{@host} is locked.") end

    @host.set_unde(target.id)
    
    return @host.answer(self,:modal,"#{topic} have left #{prev.to_s(true,true,false,false)}, and entered <i>#{target.to_s(true,true,false,false)}</i>.")
    
  end

end