#!/bin/env ruby
# encoding: utf-8

class Void

  include Vessel

  attr_accessor :unde
  attr_accessor :note
  attr_accessor :parent
  attr_accessor :owner

  def initialize

    super

    @name = "The Void"
    @note = ""
    @owner = 0

    @is_locked = true
    @is_hidden = true
    @is_quiet  = true
    @is_frozen = true

  end

  def parent

    return Void.new

  end

  def to_s show_attr = false

    return "Void"

  end

  def is_paradox

    return true

  end

end