#!/bin/env ruby
# encoding: utf-8

require_relative "wildcard.rb"

class WildcardVessel

  include Wildcard

  def initialize host = nil, value = nil

    super

    @docs = "Displays current vessel or parent vessel details."
    @options = ["id","name","attr","rank","parent id","parent name","parent attr","random id","random name","random attr"]

  end

  def to_s

    target_name = @value.split(" ").first
    target = @host
    if target_name.like("parent") then target = @host.parent end
    if target_name.like("random") then target = @host.find_random end

    target_detail = @value.split(" ").last

    if target_detail.like("id") && !target.is_hidden then return target.id.to_s end
    if target_detail.like("name") then return target.name end
    if target_detail.like("attr") then return target.attr end
    if target_detail.like("rank") then return target.rank.to_s end
    
    return "?"

  end

end
