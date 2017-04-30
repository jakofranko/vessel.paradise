#!/bin/env ruby
# encoding: utf-8

require_relative "wildcard.rb"

class WildcardLayout

  include Wildcard

  def initialize host = nil, value = nil

    super

    @docs = "The wildcard will be replaced by different layouts."
    @options = ["inventory"]

  end

  def to_s

    if @value.like("inventory") then return layout_inventory end

    return "error"

  end

  def layout_inventory

    html = ""

    @host.parent.children.each do |vessel|
      html += "<li>#{vessel}</li>"
    end

    return "<ul class='basic'>#{html}</ul>"

  end

end
