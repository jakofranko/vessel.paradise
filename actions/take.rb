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
    @target = :visible

  end

  def act target = nil, params = ""

    target = sibling_named(q)

    if !target then return @host.answer(:error,"Cannot find a target named #{q}.") end
    if target.is_locked == true then return @host.answer(:error,"#{target} is locked.") end

    target.set_unde(@host.id)

    return @host.answer(:modal,"You took #{target}.")
    
  end

end