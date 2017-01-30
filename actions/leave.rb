#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionLeave

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Leave"
    @docs = "Exit the parent vessel."

  end

  def act q = "Home"

    if @host.parent.is_stem then return @host.act("look","You may not leave #{@host.parent}. You have reached the stem of the universe.") end

    old_parent = @host.parent

    @host.set_unde(@host.parent.unde)
    
    return @host.act("look","You left #{old_parent}, and entered #{@host.parent.parent}. ")
    
  end

end