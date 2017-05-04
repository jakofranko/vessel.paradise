#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionWarp

  include Action
  
  def initialize q = nil

    super

    @name = "Warp"
    @verb = "Warping"
    @docs = "Enter a distant vessel by either its name, or its warp id. The vessel must be visible."
    @examples = ["warp to the library\n<comment>The black cat is in the library.</comment>","warp to 1\n<comment>The black cat is in the library.</comment>"]

  end

  def act params = ""

    target = @host.find_distant(params)
    prev = @host.parent

    if @host.is_locked              then return @host.answer(self,:error,"#{@host} is locked.") end
    if !target                      then return @host.answer(self,:error,"Could not find the target vessel.") end
    if target.is_hidden             then return @host.answer(self,:error,"#{target} cannot be warped into.") end
    if target.id == @host.parent.id then return @host.answer(self,:error,"#{topic} already in #{target}.") end
    
    @host.set_unde(target.id)

    return @host.answer(self,:modal,"#{topic} left #{prev} and warped to #{target}.")

  end

end