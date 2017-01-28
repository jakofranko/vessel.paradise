#!/bin/env ruby
# encoding: utf-8

class ActionUse

  include Action
  
  def initialize q = nil

    super

    @name = "Use"
    @docs = "Use an automated visible vessel."

  end

  def act q = "Home"

    target = @host.sibling(q) ; target = target ? target : @host.child(q)

    if !target then return @host.act("look","Cannot find a target named #{q}.") end
    if !target.has_program then return @host.act("look","#{target} does not have a program.") end

    action = target.program.to_s.split(" ").first

    if !@host.can(action) then return @host.act("look","The program is invalid.") end

    return @host.act(action,target.program.sub(action,"").strip)
    
  end

end