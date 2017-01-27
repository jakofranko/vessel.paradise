#!/bin/env ruby
# encoding: utf-8

class ActionEnter

  include Action
  
  def initialize q = nil

    super

    @name = "Enter"
    @docs = "TODO"

  end

  def act q = "Home"

    target = @host.sibling(q)

    if !target then return @host.act("look","Cannot find a target named #{q}.") end

    @host.set_unde(target.id)

    return @host.act("look","You entered the #{target}. ")

  end

end