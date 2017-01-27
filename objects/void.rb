#!/bin/env ruby
# encoding: utf-8

class Void

  include Vessel

  attr_accessor :unde
  attr_accessor :note
  attr_accessor :parent

  def initialize

    super

    @name = "void"
    @note = ""

  end

  def parent

    return Void.new

  end

  def to_s show_attr = false

    return "Void"

  end

  def is_stem

    return true

  end

end