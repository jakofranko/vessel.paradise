#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionUse

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Use"
    @verb = "Using"
    @docs = "Add an automation program to a vessel, making it available to the use command."
    @examples = ["use the coffee machine\n<comment>You see a coffee.</comment>"]

  end

  def act target = nil, params = ""

    target = @host.find_visible(params)
    
    if !target then return @host.answer(self,:error,"You do not see #{params}.") end
    if !target.has_program then return @host.answer(self,:error,"#{target} does not have a program.") end
    if !@host.can(target.program.action) then return @host.answer(self,:error,"The program is invalid.") end

    answer = @host.act(target.program.action,target.program.params.wildcards(@host))
    return answer
    
  end

end