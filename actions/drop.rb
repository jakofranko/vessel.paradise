#!/bin/env ruby
# encoding: utf-8

class ActionDrop

  include Action
  
  def initialize q = nil

    super

    @name = "Drop"
    @docs = "Drop a child vessel."

  end

  def act q = "Home"

    target = @host.child(q)

    if !target then return @host.act("look","Cannot find a target named #{q}.") end

    target.set_unde(@host.unde)

    return "<p>You dropped #{target}.</p>"
    
  end

end