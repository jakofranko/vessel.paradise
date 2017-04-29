#!/bin/env ruby
# encoding: utf-8

require_relative "wildcard.rb"

class WildcardTime

  include Wildcard

  def initialize host = nil, value = nil

    super

    @docs = "The wildcard will be replaced by various time data."
    @options = ["year","month","day","hour","minute","second"]

  end

  def to_s

    if @value.like("year") then return Timestamp.new.y.to_s end
    if @value.like("month") then return Timestamp.new.m.to_s end
    if @value.like("day") then return Timestamp.new.d.to_s end
    if @value.like("hour") then return Timestamp.new.H.to_s end
    if @value.like("minute") then return Timestamp.new.M.to_s end
    if @value.like("second") then return Timestamp.new.S.to_s end

    return "error"

  end

end
