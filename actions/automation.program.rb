#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionProgram

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Program"
    @verb = "Programming"
    @docs = "Add an automation program to a vessel, making it available to the use command."
    @examples = ["program create a coffee"]

  end

  def act params = ""

    target = @host.parent
    
    if params.length > 60 then return @host.answer(self,:error,"A vessel program cannot exceed 60 characters.") end
    if target.is_locked == true then return @host.answer(self,:error,"#{target} is locked.") end

    target.set_program(params)

    return @host.answer(self,:modal,"#{topic} updated #{target}'s program.")

  end

end