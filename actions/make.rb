#!/bin/env ruby
# encoding: utf-8

class ActionMake

  include Action
  
  def initialize q = nil

    super

    @name = "Make"
    @docs = "Change the attribute of the parent vessel."

  end

  def act q = "Home"

    old_attr = @host.parent.attr

    name = @host.parent.name
    attr = q.split(" ").last

    if q.to_s.strip == "" then return @host.act(:look,"You cannot remove an attribute.") end
    if !is_valid(name,attr) then return @host.act(:look,"This vessel attribute is not allowed.") end
    if !is_unique(name,attr) then return @host.act(:look,"A vessel named \"#{attr+' '+name}\" already exists somewhere.") end
    if !is_alphabetic(name,attr) then return @host.act(:look,"A vessel attribute cannot include non alphabetic characters.") end

    @host.parent.set_attr(attr)

    return "<p>You made the #{@host.parent.name} #{attr}.</p>"
    
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