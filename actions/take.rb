#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionTake

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Take"
    @docs = "Take a visible vessel."

  end

  def act q = "Home"

    target = sibling_named(q)

    if !target then return @host.act("look","Cannot find a target named #{q}.") end
    if target.is_locked == true then return "<p>#{target} is locked.</p>" end

    target.set_unde(@host.id)

    return "<p>You took #{target}.</p>"
    
  end

end