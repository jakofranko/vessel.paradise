#!/bin/env ruby
# encoding: utf-8

class ActionTransmute

  include Action
  
  def initialize q = nil

    super

    @name = "Transmute"
    @docs = "Change the name of the parent vessel."

  end

  def act q = "Home"

    old_name = @host.parent.name

    name = q.split(" ").last
    attr = @host.parent.attr

    if !is_valid(name,attr) then return @host.act(:look,"This vessel name is not allowed.") end
    if !is_unique(name,attr) then return @host.act(:look,"A vessel named \"#{attr+' '+name}\" already exists somewhere.") end
    if !is_alphabetic(name,attr) then return @host.act(:look,"A vessel name cannot include non alphabetic characters.") end

    @host.parent.set_name(name)

    return "<p>You transmuted the #{old_name} into #{@host.parent}.</p>"
    
  end

  def is_valid name,attr = ""

    $BADWORDS.each do |word|
      if name.include?(word) || attr.include?(word) then return false end
    end
    return true

  end

  def is_unique name,attr = ""

    $parade.each do |vessel|
      if vessel.name.like(name) && vessel.attr.like(attr) then return false end
    end

    return true

  end

  def is_alphabetic name,attr = ""

    if name.gsub(/[^a-z]/i, '').downcase != name then return false end
    if attr.gsub(/[^a-z]/i, '').downcase != attr then return false end

    return true

  end

end