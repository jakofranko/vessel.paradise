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

    warp_id = q.split(" ").last

    if warp_id.to_i < 1 || warp_id.to_i > 99999 then return @host.act(:look,"You cannot warp there. #{warp_id} is not a valid warp id.") end

    @host.set_unde(warp_id)

    return @host.act(:look,"You warped to #{warp_id}")

  end

end