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
    return "?"

  end

  def paradoxes

    html = ""

    $parade.each do |vessel|
      if !vessel.is_paradox then next end
      if !vessel.is_locked then next end
      if vessel.is_hidden then next end
      if vessel.id < 1 then next end
      if vessel.rank < 50 then next end

      owner = vessel.owner != 0 ? ", by the #{vessel.creator.to_s(true,false,false,false)}" : ""
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

      owner = vessel.owner != 0 ? ", by the #{vessel.creator.to_s(true,false,false,false)}" : ""
      html += "<li><action data-action='cast the #{vessel.attr} #{vessel.name}'>#{vessel.attr.capitalize} #{vessel.name.capitalize}</action>#{owner}</li>"
    end

    return "<ul class='basic'>#{html}</ul>"

  end

end
