#!/bin/env ruby
# encoding: utf-8

class ActionWarp

  include Action
  
  def initialize q = nil

    super

    @name = "Warp"
    @docs = "TODO"

  end

  def act q = "Home"

    warp_id = q.split(" ").last.to_i
    target = $parade[warp_id]

    if warp_id.to_i < 1 || warp_id.to_i > 99999 then return @host.act(:look,"You cannot warp there. #{warp_id} is not a valid warp id.") end
    if !target then return "You cannot warp to into the void." end

    @host.set_unde(target.id)

    return @host.act(:look,"You warped to #{target}.")

  end

end