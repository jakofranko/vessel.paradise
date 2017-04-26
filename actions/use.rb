#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionUse

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Use"
    @docs = "Use an automated visible vessel."
    @target = :visible
    @params = :io

  end

  def act target = nil, params = ""

    if !target then return @host.answer(:error,"Cannot find vessel.") end
    if !target.has_program then return @host.answer(:error,"#{target} does not have a program.") end
    if !@host.can(target.program.action) then return @host.answer(:error,"The program is invalid.") end

    return @host.act(target.program.action,target.program.params)
    
  end

end