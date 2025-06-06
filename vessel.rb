#!/bin/env ruby

require 'benchmark'
require_relative './corpse'

# The Paradise Vessel, mostly used to serve HTML
class VesselParadise

  include Vessel

  attr_accessor :forum, :paradise, :parade

  def initialize

    super

    @path = File.expand_path(File.join(File.dirname(__FILE__), '/'))

    load_folder("#{@path}/objects/*")
    load_folder("#{@path}/vessels/*")

    @name = 'Paradise'
    @docs = 'A multiplayer interactive fiction multiverse'

    @forum    = Memory_Array.new('forum', @path)
    @paradise = Memory_Array.new('paradise', @path)
    @parade   = @paradise.to_a('teapot')
    @tunnels = nil

    $nataniev.require('corpse', 'http')
    install(:generic, :serve, CorpseParadise.new(self))
    install(:generic, :help)

  end

  def tunnels

    return @tunnels if @tunnels

    @tunnels = []
    @parade.each do |vessel|

      next unless vessel.is_tunnel

      @tunnels.push(vessel)

    end

    @tunnels

  end

end
