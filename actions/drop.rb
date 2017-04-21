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
    @target = :child

  end

  def act q = "Home"

    target = child_named(q)

    if !target then return @host.answer(:error,"Cannot find a target named #{q}.") end
    if target.is_locked == true then return @host.answer(:error,"#{target} is locked.") end

    target.set_unde(@host.unde)

    return @host.answer(:modal,"You dropped #{target}.")
    
  end

end