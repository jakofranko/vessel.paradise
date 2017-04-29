#!/bin/env ruby
# encoding: utf-8

require_relative "wildcard.rb"

class WildcardChildren

  include Wildcard

  def initialize host = nil, value = nil

    super

    @docs = "Display children vessels. Its purpose is to access the current vessel's inventory."
    @options = ["count","random"]

  end

  def to_s

    if @value.like("count") then return @host.children.length.to_s end
    if @value.like("random") && @host.children.length > 0 then return @host.children.sample.name end

    return "error"

  end

end
