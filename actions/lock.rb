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

    @target = :parent

  end

  def act target = nil, params = ""

    attr = q.split(" ").last
    
    if @host.parent.is_locked == true then return @host.answer(:error,"#{@host.parent} is already locked.") end
    if @host.parent.owner != @host.id then return @host.answer(:error,"You do not own #{@host.parent}.") end

    @host.parent.set_locked(true)

    return @host.answer(:modal,"You locked the #{@host.parent.name}.")
    
  end

end