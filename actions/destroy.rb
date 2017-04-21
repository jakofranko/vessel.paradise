#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionDestroy

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Destroy"
    @docs = "Destroy the target owned vessel."
    @target = :visible

  end

  def act q = "Home"

    target = visible_named(q)

    return target.destroy

    attr = q.split(" ").last
    
    if @host.parent.is_locked == false then return "<p>#{@host.parent} is not locked.</p>" end
    if @host.parent.owner != @host.id then return "<p>You do not own #{@host.parent}.</p>" end

    @host.parent.set_locked(false)

    return "<p>You unlocked the #{@host.parent.name}.</p>"
    
  end

end