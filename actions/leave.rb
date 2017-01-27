#!/bin/env ruby
# encoding: utf-8

class ActionLeave

  include Action
  
  def initialize q = nil

    super

    @name = "Leave"
    @docs = "TODO"

  end

  def act q = "Home"

    return "You left the #{@host.parent}."

  end

end