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
    @params = :visible

  end

  def act q = "Home"

    target = visible_named(q)

    if !target then return @host.answer(:error,"Cannot find a target named #{q}.") end
    if !target.has_program then return @host.answer(:error,"#{target} does not have a program.") end

    action = target.program.to_s.split(" ").first

    if !@host.can(action) then return @host.answer(:error,"The program is invalid.") end

    return @host.act(action,wildcard(target.program).sub(action,"").strip)
    
  end

end