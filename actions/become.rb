#!/bin/env ruby
# encoding: utf-8

class ActionBecome

  include Action
  
  def initialize q = nil

    super

    @name = "Become"
    @docs = "TODO"

  end

  def act q = "Home"

    target = @host.sibling(q) ; target = target ? target : @host.child(q)

    if !target then return @host.act("look","Cannot find a target named #{q}.") end

    return "<p>You are becoming #{target}...</p>
    <meta http-equiv='refresh' content='2; url=/#{target.id}' />"

  end

end