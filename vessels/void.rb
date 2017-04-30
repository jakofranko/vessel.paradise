#!/bin/env ruby
# encoding: utf-8

class VesselVoid

  include Vessel
  include VesselToolkit

  attr_accessor :unde
  attr_accessor :note
  attr_accessor :parent
  attr_accessor :owner
  
  attr_accessor :is_locked
  attr_accessor :is_hidden
  attr_accessor :is_silent
  attr_accessor :is_tunnel

  def initialize content = nil

    super

    @name = "The Void"
    @note = ""
    @owner = 0

    @is_locked = true
    @is_hidden = true
    @is_silent = true
    @is_tunnel = true

  end

  def act action_name, params = nil

    return "The void cannot act."

  end

  def parent

    return VesselVoid.new

  end

  def is_paradox

    return true

  end

end