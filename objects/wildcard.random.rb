#!/bin/env ruby
# encoding: utf-8

require_relative "wildcard.rb"

class WildcardRandom

  include Wildcard

  def initialize host = nil, value = nil

    super

    @docs = "Displays a random word."
    @options = ["red,green,blue"]

  end

  def to_s

    words = @value.split(",")
    return words.sample

  end

end
