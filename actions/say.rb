#!/bin/env ruby
# encoding: utf-8

class ActionSay

  include Action
  
  def initialize q = nil

    super

    @name = "Say"
    @docs = "TODO"

  end

  def act q = "Home"

    return "hey"
    
  end

end