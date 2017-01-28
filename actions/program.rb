#!/bin/env ruby
# encoding: utf-8

class ActionProgram

  include Action
  
  def initialize q = nil

    super

    @name = "Program"
    @docs = "Automate the parent vessel."

  end

  def act q = "Home"

    if q.length > 40 then return "<p>A vessel program cannot exceed 40 characters.</p>" end

    if q.length < 5
      @host.parent.set_program("")
      return "<p>You have removed #{@host.parent} program.</p>" 
    end

    @host.parent.set_program(q)

    return "<p>You programmed #{@host.parent}.</p>"

  end

end