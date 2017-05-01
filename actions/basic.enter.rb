#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionEnter

  include Action
  
  def initialize q = nil

    super

    @name = "Enter"
    @docs = "Enter a visible vessel."
    @verb = "Entering"
    @examples = ["enter the library\n<comment>You are in the library.</comment>"]

  end

  def act params = ""

    target = @host.find_visible(params)
    prev = @host.parent
    
    if !target                      then return @host.answer(self,:error,"#{topic} could not find the target vessel.") end
    if target.id == @host.parent.id then return @host.answer(self,:error,"#{topic} already are in #{target.to_s(true,true,false,false)}.") end
      if @host.is_locked == true    then return @host.answer(self,:error,"#{@host} is locked.") end

    @host.set_unde(target.id)

    return @host.answer(self,:modal,"#{topic} have entered the #{target.to_s(true,false,false,false)}. ", "Press <b>enter</b> to continue or type <action data-action='leave'>leave</action> to return to #{prev.to_s(true,true,false,false)}.")

  end

end