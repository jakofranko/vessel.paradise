#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionCreate

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Create"
    @docs = "Create a new vessel."

  end

  def act q = "Home" 

    target = remove_articles(q).split(" ")

    name = target.last
    attr = target.length == 2 ? target[target.length-2] : ""

    # Lengths
    if name.length < 3 then return @host.act(:look,"The vessel name is too short.") end
    if name.length > 14 then return @host.act(:look,"The vessel name is too long.") end
    if attr.length > 14 then return @host.act(:look,"The vessel attribute is too long.") end
    
    # Checks

    if !is_unique(name,attr) then return @host.act(:look,"A vessel named \"#{attr+' '+name}\" already exists somewhere.") end
    if !is_valid(name) then return @host.act(:look,"This vessel name is not allowed.") end
    if !is_valid(attr) then return @host.act(:look,"This vessel attribute is not allowed.") end
    if !is_alphabetic(name) then return @host.act(:look,"A vessel name cannot include non alphabetic characters.") end
    if !is_alphabetic(attr) then return @host.act(:look,"A vessel attribute cannot include non alphabetic characters.") end

    new_vessel = Ghost.new({"NAME" => name.downcase,"ATTR" => attr.downcase,"CODE" => "0000-#{@host.unde.to_s.prepend('0',5)}-#{@host.id.to_s.prepend('0',5)}-#{Timestamp.new}"})

    $paradise.append(new_vessel.encode)
    @host.reload

    return "You created #{new_vessel}."

  end

end