#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionMake

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Make"
    @docs = "Change the attribute of the parent vessel."

  end

  def act q = "Home"

    attr = q.split(" ").last

    if !is_long_enough(attr) then return @host.act(:look,"This vessel attribute is too short.") end
    if !is_valid(attr) then return @host.act(:look,"This vessel attribute is not allowed.") end
    if !is_alphabetic(attr) then return @host.act(:look,"A vessel attribute cannot include non alphabetic characters.") end
    if !is_unique(name,attr) then return @host.act(:look,"A vessel named \"#{attr+' '+name}\" already exists somewhere.") end
    if @host.is_locked == true then return "<p>#{@host} is locked.</p>" end
    
    @host.parent.set_attr(attr)

    return "<p>You made the #{@host.parent.name}, #{attr}.</p>"
    
  end

end