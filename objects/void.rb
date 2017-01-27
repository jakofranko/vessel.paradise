#!/bin/env ruby
# encoding: utf-8

class Void

  include Vessel

  attr_accessor :unde
  attr_accessor :note
  attr_accessor :parent

  def initialize

    super

    @note = ""

  end

  def parent

    return Void.new

  end

  def to_s

    return "Blank"

  end

end