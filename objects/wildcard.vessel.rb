#!/bin/env ruby
# encoding: utf-8

require_relative "wildcard.rb"

class WildcardVessel

  include Wildcard

  def initialize host = nil, value = nil

    super

    @docs = "Displays current vessel or parent vessel details."
    @options = ["id","name","attr","rank","parent id","parent name","parent attr"]

  end

  def to_s

    if @value.like("parent id") && !@host.parent.is_hidden then return @host.parent.id.to_s end
    if @value.like("parent name") then return @host.parent.attr end
    if @value.like("parent attr") then return @host.parent.attr end

    if @value.like("id") && !@host.is_hidden then return @host.id.to_s end
    if @value.like("name") then return @host.name end
    if @value.like("attr") then return @host.attr end
    if @value.like("rank") then return @host.rank.to_s end
    
    return "?"

  end

end
