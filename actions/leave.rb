#!/bin/env ruby
# encoding: utf-8

class ActionLeave

  include Action
  
  def initialize q = nil

    super

    @name = "Leave"
    @docs = "Exit the parent vessel."

  end

  def act q = "Home"

    @host.set_unde(@host.parent.unde)

    if @host.parent.is_stem then return @host.act("look","You may not leave #{@host.parent}. You have reached the stem of the universe.") end

    return @host.act("look","You left #{@host.parent}, and entered #{@host.parent.parent}. ")
    
  end

end