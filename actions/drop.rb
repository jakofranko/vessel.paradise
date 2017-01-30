#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionDrop

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Drop"
    @docs = "Drop a child vessel."

  end

  def act q = "Home"

    target = child_named(q)

    if !target then return @host.act("look","Cannot find a target named #{q}.") end

    target.set_unde(@host.unde)

    return "<p>You dropped #{target}.</p>"
    
  end

end