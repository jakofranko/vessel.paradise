#!/bin/env ruby
# encoding: utf-8

class ActionProgram

  include Action
  
  def initialize q = nil

    super

    @name = "Program"
    @docs = "TODO"

  end

  def act q = "Home"

    if q.length > 40 then return "A vessel program cannot exceed 40 characters." end

    if q.length < 5
      @host.parent.set_program("")
      return "You have removed #{@host.parent} program." 
    end

    @host.parent.set_program(q)

    return "You programmed #{@host.parent}. "

  end

end