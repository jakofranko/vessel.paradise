#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionCall

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Call"
    @docs = "Call a distant program."

    @target = :warp_id

  end

  def act target = nil, params = ""

    if !target then return @host.answer(:error,"The target vessel did not answer.") end
    if !target.has_program then return @host.answer(:error,"The target vessel has no program.") end

    return target.act(target.program.action,target.program.params)

  end

end