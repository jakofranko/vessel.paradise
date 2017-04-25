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

  def act target = nil, params = ""

    attr = q.split(" ").last
    
    if @host.parent.is_locked == false then return @host.answer(:error,"#{@host.parent} is not locked.") end
    if @host.parent.owner != @host.id then return @host.answer(:error,"You do not own #{@host.parent}.") end

    @host.parent.set_locked(false)

    return @host.answer(:modal,"You unlocked the #{@host.parent.name}.")
    
  end

end