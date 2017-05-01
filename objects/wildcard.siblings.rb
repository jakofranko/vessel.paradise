#!/bin/env ruby
# encoding: utf-8

require_relative "wildcard.rb"

class WildcardSiblings

  include Wildcard

  def initialize host = nil, value = nil

    super

    @docs = "Display sibling vessels."
    @options = ["count","random"]

  end

  def to_s

    if @value.like("count") then return @host.siblings.length.to_s end
    if @value.like("random") && @host.siblings.length > 0 then return @host.siblings.sample.name end
    if @value.like("list") && @host.siblings.length > 0 then return list end

    return "error"

  end

  def list

    html = ""

    @host.siblings.each do |vessel|
      owner = vessel.owner != 0 ? ", by the #{vessel.creator.to_s(true,false,false,false)}" : ""
      html += "<li><action data-action='cast the #{vessel.attr} #{vessel.name}'>#{vessel.attr.capitalize} #{vessel.name.capitalize}</action>#{owner}</li>"
    end

    return "<ul class='basic'>#{html}</ul>"

  end

end
