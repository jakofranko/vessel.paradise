#!/bin/env ruby
# encoding: utf-8

class ActionTransmute

  include Action
  
  def initialize q = nil

    super

    @name = "Drop"
    @docs = "TODO"

  end

  def act q = "Home"

    old_name = @host.parent.name

    name = q.split(" ").last

    @host.parent.set_name(name)

    return "You transmuted the #{old_name} into a #{name}. "
    
  end

end