#!/bin/env ruby
# encoding: utf-8

module Action

  attr_accessor :verb

  attr_accessor :params
  attr_accessor :target
  attr_accessor :examples
  
  def topic

    return $player_id == @host.id ? "You" : "The #{@host.name}"

  end

  def is_improvement before,after

    words_before = {}
    before.split(" ").each do |word|
      words_before[word] = words_before[word].to_i + 1
    end

    words_after = {}
    after.split(" ").each do |word|
      words_after[word] = words_after[word].to_i + 1
    end

    ratio = words_after.length.to_f / words_before.length.to_f

    if ratio < 0.2 then return nil end

    return true

  end

end

module ActionToolkit

  def initialize host = nil

    super

    @examples = {}

  end
  
end
