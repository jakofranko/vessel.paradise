#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionDrop

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Drop"
    @docs = "Move a child vessel into the parent vessel."
    @examples = ["drop the scissor\n<comment>You see the scissor.</comment>"]

  end

  def act target = nil, params = ""

    target = child_named(q)

    if !target then return @host.answer(:error,"Cannot find a target named #{q}.") end
    if target.is_locked == true then return @host.answer(:error,"#{target} is locked.") end

    target.set_unde(@host.unde)

    return @host.answer(:modal,"You dropped #{target}.")
    
  end

end