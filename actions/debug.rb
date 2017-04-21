#!/bin/env ruby
# encoding: utf-8

class ActionDebug

  include Action

  def initialize q = nil

    super

    @name = "Debug"
    @docs = "Test paradise for errors."

  end

  def act q = nil

    load_folder("#{@host.path}/objects/*")

    $forum           = Memory_Array.new("forum",@host.path)
    $paradise        = Memory_Array.new("paradise",@host.path)
    $parade          = $paradise.to_a("ghost")

    load_folder("#{@host.path}/actions/*")

    id = 0
    $parade.each do |vessel|
      vessel.id = id
      id += 1
    end

    vessel = $parade[589] # select_random_vessel
    vessel.id = 589

    puts "------------------"
    puts "BASICS(#{vessel.to_debug})"
    puts "------------------"

    puts vessel.act("warp","1")
    puts vessel.act("leave","")
    puts vessel.act("enter","the book")
    puts vessel.act("create","a benchmark tool")
    puts vessel.act("enter","the tool")

    puts "------------------"
    puts "PARENT(#{vessel.to_debug})"
    puts "------------------"

    return "done."

  end

  def select_random_vessel

    candidates = []
    $parade.each do |vessel|
      if vessel.rank > 0 then next end
      candidates.push(vessel)
    end

    candidate = candidates.length > 0 ? candidates[rand(candidates.length)].id : rand($parade.length)

    return candidate.to_i

  end

end