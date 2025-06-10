#!/bin/env ruby
require_relative 'wildcard'

# For displaying time-stamps
class WildcardTime

  include Wildcard

  def initialize(host = nil, value = nil)

    super

    @docs = 'The wildcard will be replaced by various time data. '\
      'Paradise is using <a href="http://wiki.xxiivv.com/Desamber">Desamber</a> time.'
    @options = %w[date year month day clock above below]

  end

  def to_s

    d = Desamber.new

    return d.to_s if @value.like('date')
    return d.y.to_s if @value.like('year')
    return d.m.to_s if @value.like('month')
    return d.d.to_s if @value.like('day')
    return d.clock.to_s if @value.like('clock')
    return d.above.to_s if @value.like('above')
    return d.below.to_s if @value.like('below')

    'error'

  end

end
