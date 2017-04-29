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

    return "error"

  end

end
