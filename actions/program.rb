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

  end

  def act q = "Home"

    if q.length > 60 then return "<p>A vessel program cannot exceed 60 characters.</p>" end

    @host.parent.set_program(q)

    return "<p>You updated #{@host.parent}'s program.</p>"

  end

end