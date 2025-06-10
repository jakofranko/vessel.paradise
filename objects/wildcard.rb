#!/bin/env ruby

# Base wildcard functionality
module Wildcard

  attr_accessor :value, :docs, :options

  def initialize(host = nil, value = nil)

    @host = host
    @value = value
    @docs = 'Missing'
    @options = []

  end

  def to_s

    @value

  end

end
