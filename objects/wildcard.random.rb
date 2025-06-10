#!/bin/env ruby
require_relative 'wildcard'

# Adds ability to pick random text from a list
class WildcardRandom

  include Wildcard

  def initialize(host = nil, value = nil)

    super

    @docs = 'Displays a random word from a series of words, separated by commas.'
    @options = ['red,green,blue']

  end

  def to_s

    words = @value.split(',')
    words.sample

  end

end
