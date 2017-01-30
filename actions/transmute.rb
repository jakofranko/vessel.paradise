#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionTransmute

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Transmute"
    @docs = "Change the name of the parent vessel."

  end

  def act q = "Home"

    old_name = @host.parent.name

    name = q.split(" ").last

    if !is_valid(name) then return @host.act(:look,"This vessel name is not allowed.") end
    if !is_unique(name,@host.parent.attr) then return @host.act(:look,"A vessel named \"#{name}\" already exists somewhere.") end
    if !is_alphabetic(name) then return @host.act(:look,"A vessel name cannot include non alphabetic characters.") end

    @host.parent.set_name(name)

    return "<p>You transmuted the #{old_name} into #{@host.parent}.</p>"
    
  end

end