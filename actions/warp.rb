#!/bin/env ruby
# encoding: utf-8

class ActionWarp

  include Action
  
  def initialize q = nil

    super

    @name = "Warp"
    @docs = "Enter a distant vessel from warp id."

  end

  def act q = "Home"

    warp_id = q.split(" ").last.to_i
    target = $parade[warp_id]

    if q.to_s.strip == "" then return @host.act(:look,"You need to input a warp id.") end

    if warp_id.to_i < 1 || warp_id.to_i > 99999 then return @host.act(:look,"You cannot warp there. #{warp_id} is not a valid warp id.") end
    if !target then return "<p>You cannot warp to into the void.</p>" end

    @host.set_unde(target.id)

    return @host.act(:look,"You warped to #{target}.")

  end

end