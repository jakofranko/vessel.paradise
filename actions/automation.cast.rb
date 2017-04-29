#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionCast

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Cast"
    @docs = "Use a vessel program's from anywhere."
    @examples = ["cast the vanish spell onto the black cat\n<comment>The black cat is now hidden.</comment>"]


  end

  def act target = nil, params = ""

    if !target then return @host.answer(:error,"The target vessel did not answer.") end
    if !target.has_program then return @host.answer(:error,"The target vessel has no program.") end

    return target.act(target.program.action,target.program.params)

  end

end