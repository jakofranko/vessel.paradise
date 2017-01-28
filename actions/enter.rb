#!/bin/env ruby
# encoding: utf-8

class ActionEnter

  include Action
  
  def initialize q = nil

    super

    @name = "Enter"
    @docs = "Enter a visible vessel."

  end

  def act q = "Home"

    target = @host.sibling(q) ; target = target ? target : @host.child(q)

    if !target then return @host.act("look","Cannot find a target named #{q}.") end

    @host.set_unde(target.id)

    return @host.act("look","You entered #{target}. ")

  end

end