#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionUnlock

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Unlock"
    @docs = "Unlock the parent vessel."

    @target = :parent
    
  end

  def act q = "Home"

    attr = q.split(" ").last
    
    if @host.parent.is_locked == false then return "<p>#{@host.parent} is not locked.</p>" end
    if @host.parent.owner != @host.id then return "<p>You do not own #{@host.parent}.</p>" end

    @host.parent.set_locked(false)

    return "<p>You unlocked the #{@host.parent.name}.</p>"
    
  end

end