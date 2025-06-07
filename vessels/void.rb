#!/bin/env ruby

# Void space
class VesselVoid

  include Vessel
  # include VesselToolkit

  attr_accessor :unde, :owner, :is_locked, :is_hidden, :is_silent, :is_tunnel

  attr_writer :note, :parent

  def initialize(content = nil)

    super

    @name = 'Void'
    @note = ''
    @owner = 0

    @is_locked = true
    @is_hidden = true
    @is_silent = true
    @is_tunnel = true

  end

  def to_s
    'Void'
  end

  def act(_action_name, _params = nil)

    'The void cannot act.'

  end

  def parent

    VesselVoid.new

  end

  def is_paradox

    true

  end

  def creator
    VesselVoid.new
  end

  def rating
    0
  end

  def depth
    0
  end

  def stem
    VesselVoid.new
  end

  def has_program
    false
  end

  def has_note
    true
  end

  def note
    'You find yourself in the void. A pocket of unused and immutable vessel space. '
  end

  def guides

    ['Sector is unmonitored by service vessels.',
     'The void is unstable, vessels created here my be moved or destroyed.']
  end

end
