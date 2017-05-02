#!/bin/env ruby
# encoding: utf-8

require_relative "wildcard.rb"

class WildcardParadise

  include Wildcard

  def initialize host = nil, value = nil

    super

    @docs = "Displays paradise core layouts."
    @options = ["paradoxes"]

  end

  def to_s

    if @value.like("paradoxes") then return paradoxes end
    if @value.like("spells") then return spells end
    if @value.like("glossary") then return glossary end
    if @value.like("tunnels") then return tunnels end

    return "?"

  end

  def paradoxes

    html = ""

    $parade.each do |vessel|
      if !vessel.is_paradox then next end
      if !vessel.is_locked then next end
      if vessel.is_hidden then next end
      if vessel.id < 1 then next end
      if vessel.rating < 50 then next end

      owner = vessel.owner != 0 ? ", by the #{vessel.creator}" : ""
      html += "<li><action data-action='warp to #{vessel.id}'>#{vessel.attr.capitalize} #{vessel.name.capitalize}</action>#{owner}</li>"
    end

    return "<ul class='basic'>#{html}</ul>"

  end

  def spells

    html = ""

    $parade.each do |vessel|
      if !vessel.has_program then next end
      if !vessel.is_locked then next end
      if !vessel.has_attr then next end
      if !vessel.name.like("spell") then next end

      owner = vessel.owner != 0 ? ", by the #{vessel.creator}" : ""
      html += "<li><action data-action='cast the #{vessel.attr} #{vessel.name}'>#{vessel.attr.capitalize} #{vessel.name.capitalize}</action>#{owner}</li>"
    end

    return "<ul class='basic'>#{html}</ul>"

  end

  def tunnels

    html = ""

    $parade.each do |vessel|
      if vessel.is_hidden then next end
      if !vessel.has_note then next end
      if !vessel.is_locked then next end
      if !vessel.note.include?("train station") then next end
      if vessel.id == @host.parent.id then next end

      owner = vessel.owner != 0 ? ", by the #{vessel.creator}" : ""
      html += "<li><action data-action='warp to the #{vessel.attr} #{vessel.name}'>#{vessel.attr.capitalize} #{vessel.name.capitalize}</action>#{owner}</li>"
    end

    return "<ul class='basic'>#{html}</ul>"

  end

  def glossary

    g = {}
    g["a vessel"] = "is a ghost carrier. A pocket of conceptspace that has an attribute and a name, that can travel through Paradise."
    g["a paradox"] = "is impossible space, often folded onto itself, creating stems to universes."
    g["the parade"] = "is the sum of Paradise's activity."
    g["a tunnel"] = "is a vessel or action type accessible across all space. Cast and Warp are tuneling actions, allowing a ghost to traverse distances instantly. A tuneling vessel will be accessible through notes across distances."
    g["the haven"] = "is a tutorial region with various documentation vessels."
    g["nullspace"] = "is a warp id disassociated from a vessel."
    g["a ghost"] = "is a vessel controller, a player."
    g["conceptspace"] = "is the sum of vessels with non-spacial attributes, or hard to visualize attributes. "
    g["thingspace"] = "is the sum of vessels with eucledian and real-world attributes."
    g["the void"] = "is unbuilt vessel space."
    g["the negative void"] = "is unbuilt vessel space with negative IDs."
    g["cyan mass"] = "is the sum of the cyan faction vessels."
    g["red spawn"] = "is the sum of the red faction vessels."
    g["a signal"] = "is the broadcasting of a warp id."
  
    html = ""    
    g.sort.each do |term,definition|
      html += "<li><b>#{term.capitalize}</b>, #{definition}</li>"
    end
    return "<ul class='basic'>#{html}</ul>"

  end

end
