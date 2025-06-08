#!/bin/env ruby

# Translate a string to a Paradise action, stored on a vessel as a program
class Program

  attr_accessor :host, :raw, :action, :params

  def initialize(host, raw = nil)

    @host = host
    @raw = raw.to_s
    @action = @raw.split(' ').first.to_s.strip
    @params = @raw.gsub(@action, '').strip

  end

  def to_s

    @raw

  end

  def type

    return 'warp ' if action.like('warp')
    return 'machine ' if action.like('create')
    return 'speaker ' if action.like('say')

    'generic'

  end

  def render

    @raw.wildcards(@host)

  end

  def is_valid

    return false if @raw.length > 60

    @host.can(@action)

  end

end
