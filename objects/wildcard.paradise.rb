#!/bin/env ruby
# encoding: utf-8

require_relative "wildcard.rb"

class WildcardParadise

  include Wildcard

  def initialize host = nil, value = nil

    super

    @docs = "Displays paradise core layouts."
    @options = ["paradoxes", "spells", "glossary", "tunnels"]

  end

  def to_s

    if @value.like("paradoxes") then return paradoxes end
    if @value.like("spells") then return spells end
    if @value.like("glossary") then return glossary end
    if @value.like("tunnels") then return tunnels end

    # Secrets
    if @value.like("train_stations") then return train_stations end
    if @value.like("cyan count") then return cyan_count end
    if @value.like("red count") then return red_count end
    if @value.like("cyan list") then return cyan_list end
    if @value.like("red list") then return red_list end

    return "?"

  end

  def paradoxes

    html = ""

    $nataniev.vessels[:paradise].corpse.parade.each do |vessel|
      if !vessel.is_paradox then next end
      if !vessel.is_locked then next end
      if vessel.is_hidden then next end
      if vessel.memory_index < 1 then next end
      if vessel.rating < 50 then next end

      owner = vessel.owner != 0 ? ", by the #{vessel.creator}" : ""
      html += "<li><action-link data-action='warp to #{vessel.memory_index}'>#{vessel.attr.capitalize} #{vessel.name.capitalize}</action-link>#{owner}</li>"
    end

    return "<ul class='basic'>#{html}</ul>"

  end

  def spells

    html = ""

    $nataniev.vessels[:paradise].corpse.parade.each do |vessel|
      if !vessel.has_program then next end
      if !vessel.is_locked then next end
      if !vessel.has_attr then next end
      if !vessel.name.like("spell") then next end

      owner = vessel.owner != 0 ? ", by the #{vessel.creator}" : ""
      html += "<li><action-link data-action='cast the #{vessel.attr} #{vessel.name}'>#{vessel.attr.capitalize} #{vessel.name.capitalize}</action-link>#{owner}</li>"
    end

    return "<ul class='basic'>#{html}</ul>"

  end

  def tunnels

    html = ""

    $nataniev.vessels[:paradise].tunnels.each do |vessel|
      if !vessel.is_tunnel then next end
      if vessel.is_hidden then next end
      if vessel.memory_index == @host.parent.memory_index then next end
      if vessel.rating < 50 then next end

      owner = vessel.owner != 0 ? ", by the #{vessel.creator}" : ""
      html += "<li><action-link data-action='warp to #{vessel.memory_index}'>#{vessel.attr.capitalize} #{vessel.name.capitalize}</action-link>#{owner}</li>"
    end

    return "<ul class='basic'>#{html}</ul>"

  end

  def train_stations

    html = ""

    $nataniev.vessels[:paradise].corpse.parade.each do |vessel|
      if vessel.is_hidden then next end
      if !vessel.has_note then next end
      if !vessel.is_locked then next end
      if !vessel.note.include?("train station") then next end
      if vessel.memory_index == @host.parent.memory_index then next end

      owner = vessel.owner != 0 ? ", by the #{vessel.creator}" : ""
      html += "<li><action-link data-action='warp to #{vessel.memory_index}'>#{vessel.attr.capitalize} #{vessel.name.capitalize}</action-link>#{owner}</li>"
    end

    return "<ul class='basic'>#{html}</ul>"

  end

  def glossary

    g = {}

    g[:general] = {}
    g[:general]["a vessel"] = "is a pocket of conceptspace with an attribute and a name, able to traverse Paradise."
    g[:general]["a paradox"] = "is impossible space folded onto itself, and stems to universes. "
    g[:general]["a tunnel"] = "is a vessel or action type accessible across all space. Cast and Warp are tuneling actions, allowing ghosts to traverse vast distances instantly. A tuneling vessel will be accessible through notes across distances."
    g[:general]["a signal"] = "is the broadcasting of a warp id."
    g[:general]["the parade"] = "is another name for all of Paradise's activity."
    g[:general]["the haven"] = "is a tutorial region with various documentation vessels."

    g[:void] = {}
    g[:void]["the void"] = "is generic unbuilt vessel space, any warp id that is yet unused."
    g[:void]["the ultravoid"] = "is the hyptothesized vessel space of negative warp id."

    g[:factions] = {}
    g[:factions]["cyan mass"] = "is the sum of the cyan vessels."
    g[:factions]["red spawn"] = "is the sum of the red vessels."


    g[:fashion] = {}
    g[:fashion]["thingspace"] = "is a type of vessels with eucledian and real-world attributes. Often the default simplistic mindset of new players."
    g[:fashion]["conceptspace"] = "is a type of vessels with non-spacial attributes, or hard to visualize attributes. It has been suggested that the Parade is a research project exploring the limits of conceptspace."
    g[:fashion]["illegalspace"] = "is a type of vessels with non-paradise attributes, often the result of exploits. A vessel with a number for a name, for instance."


    html = ""
    g.each do |cat,terms|
      html += "<h4>#{cat}</h4>"
      html += "<ul class='basic' style='margin-bottom:30px'>"
      terms.each do |term,definition|
        html += "<li><b>#{term.capitalize}</b>, #{definition}</li>"
      end
      html += "</ul>"

    end
    return html

  end

  def cyan_count

    count = 0
    $nataniev.vessels[:paradise].corpse.parade.each do |vessel|
      if vessel.attr.like("cyan") then
        count += 1
      end
    end

    return "<span class='cyan'>#{count.to_s}</span>"

  end

  def red_count

    count = 0
    $nataniev.vessels[:paradise].corpse.parade.each do |vessel|
      if vessel.attr.like("red") then
        count += 1
      end
    end

    return "<span class='red'>#{count.to_s}</span>"

  end

  def cyan_list

    html = "<ul class='cyan basic'>"
    $nataniev.vessels[:paradise].corpse.parade.each do |vessel|
      if vessel.attr.like("cyan") then
        html += "<li>#{vessel.to_s}</li>"
      end
    end

    html += "</ul>"
    return html

  end

  def red_list

    html = "<ul class='red basic'>"
    $nataniev.vessels[:paradise].corpse.parade.each do |vessel|
      if vessel.attr.like("red") then
        html += "<li>#{vessel.to_s}</li>"
      end
    end

    html += "</ul>"
    return html

  end

end
