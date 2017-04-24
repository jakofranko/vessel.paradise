#!/bin/env ruby
# encoding: utf-8

class Program

  attr_accessor :raw

  def initialize raw = nil

    @raw = raw.to_s

  end

  def to_s

    return @raw

  end

end
