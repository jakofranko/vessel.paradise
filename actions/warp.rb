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

    # @host.set_unde(@host.parent.unde)

    # if @host.parent.is_stem then return @host.act("look","You may not leave the #{@host.parent}. You have reached the stem of the universe.") end

    # return @host.act("look","You left the #{@host.parent}, and entered the #{@host.parent.parent}. ")
    
  end

end