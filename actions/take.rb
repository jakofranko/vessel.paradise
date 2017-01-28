#!/bin/env ruby
# encoding: utf-8

class ActionTake

  include Action
  
  def initialize q = nil

    super

    @name = "Leave"
    @docs = "TODO"

  end

  def act q = "Home"

    target = @host.sibling(q)

    if !target then return @host.act("look","Cannot find a target named #{q}.") end

    target.set_unde(@host.id)

    return "You took the #{target}. "
    
  end

end