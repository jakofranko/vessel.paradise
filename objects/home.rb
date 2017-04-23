#!/bin/env ruby
# encoding: utf-8

class VesselHome

  include Vessel
  include VesselToolkit

  def initialize content = nil

    super

    @name = "Home"

  end

  def sight

    return "(Home)"
    
  end

end