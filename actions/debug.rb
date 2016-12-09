#!/bin/env ruby
# encoding: utf-8

class ActionDebug

  include Action
  
  def initialize q = nil

    super

    @name = "Debug"
    @docs = "Paradise Crawler."

  end

  def act q = "Home"

    return "TODO"

  end

end