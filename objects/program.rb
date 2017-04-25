#!/bin/env ruby
# encoding: utf-8

class Program

  attr_accessor :raw
  attr_accessor :action
  attr_accessor :params

  def initialize raw = nil

    @raw = raw.to_s
    @action = @raw.split(" ").first.to_s.strip
    @params = @raw.gsub(@action,"").strip

  end

  def to_s

    return @raw

  end

  def type

    if action.like("warp") then return "warp " end
    if action.like("create") then return "machine " end
    if action.like("say") then return "speaker " end
    return "generic"

  end

end
