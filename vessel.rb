#!/bin/env ruby
# encoding: utf-8

class VesselParadise

  include Vessel

  def initialize id = 0

    super

    @name = "Paradise"
    @path = File.expand_path(File.join(File.dirname(__FILE__), "/"))
    @docs = "The Paradise Library toolchain."
    @site = "http://paradise.xxiivv.com"
    
    install(:custom,:serve)
    install(:generic,:document)
    install(:generic,:help)

  end

end