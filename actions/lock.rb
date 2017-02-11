#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionLock

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Lock"
    @docs = "Lock the parent vessel."

  end

  def act q = "Home"

    attr = q.split(" ").last
    
    if @host.parent.is_locked == true then return "<p>#{@host.parent} is already locked.</p>" end
    if @host.parent.owner != @host.id then return "<p>You do not own #{@host.parent}.</p>" end

    @host.parent.set_locked(true)

    return "<p>You locked the #{@host.parent.name}.</p>"
    
  end

end