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

    # Tunnels
    @tunnels = nil
    @tunnels_changed = true
    @tunnels_mutex = Mutex.new

    # I believe this actually sets the Paradise vessel's corpse
    # to be the CorpseParadise...which is not great.
    # Install seems to set the vessel's @corpse attribute if passed,
    # and this can get overridden if I were to install another action
    # with a different corpse. Actions should be refactored to have their
    # own corpses, methinks....
    install(:generic, :serve, CorpseParadise.new(self))
    install(:generic, :help)

  end

  def tunnels

    return @tunnels unless @tunnels_changed

    @tunnels_mutex.synchronize do

      # Check again in case a different thread has updated the tunnels
      return @tunnels unless @tunnels_changed

      @tunnels = []
      @parade.each do |vessel|

        next unless vessel.is_tunnel

        @tunnels.push(vessel)

      end

      @tunnels_changed = false

      @tunnels

    end

  end

end
