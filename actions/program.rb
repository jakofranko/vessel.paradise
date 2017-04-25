#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionProgram

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Program"
    @docs = "Automate the parent vessel."
    
    @target = :parent
    @params = :action

  end

  def act target = nil, params = ""

    if q.length > 60 then return @host.answer(:error,"A vessel program cannot exceed 60 characters.") end
    if @host.parent.is_locked == true then return @host.answer(:error,"#{@host.parent} is locked.") end

    @host.parent.set_program(q)

    return @host.answer(:modal,"You updated #{@host.parent}'s program.")

  end

end