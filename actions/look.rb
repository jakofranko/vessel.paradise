#!/bin/env ruby
# encoding: utf-8

class ActionLook

  include Action
  
  def initialize q = nil

    super

    @name = "Look"
    @docs = "Sight."

  end

  def act q = "Home"

    return "You are the #{@host} in a #{@host.parent} of the #{@host.parent.parent}."

  end

end