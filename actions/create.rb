#!/bin/env ruby
# encoding: utf-8

class ActionCreate

  include Action
  
  def initialize q = nil

    super

    @name = "Create"
    @docs = "TODO"

  end

  def act q = "Home" 

    target = q.split(" ")

    name = target.last
    attr = target[target.length-2] ? target[target.length-2] : ""

    if name.length < 3 then return @host.act(:look,"The vessel name is too short.") end
    if attr.length < 3 then attr = "" end
    if !is_valid(name,attr) then return @host.act(:look,"The vessel name is invalid.") end
    if !is_unique(name,attr) then return @host.act(:look,"The vessel name is already used somewhere, consider adding an adjective.") end

    new_vessel = Ghost.new({"NAME" => name,"ATTR" => attr,"CODE" => "0000-#{@host.unde.to_s.prepend('0',5)}-#{@host.id.to_s.prepend('0',5)}-#{Timestamp.new}"})

    $paradise.append(new_vessel.encode)
    @host.reload

    return "Created a #{new_vessel}."

  end

  def is_valid name,attr

    bad_dict = ["dick","pussy","asshole","nigger"]

    bad_dict.each do |word|
      if name.include?(word) || attr.include?(word) then return false end
    end
    return true

  end

  def is_unique name,attr

    $parade.each do |vessel|
      if vessel.name.like(name) && vessel.attr.like(attr) then return false end
    end

    return true

  end

end