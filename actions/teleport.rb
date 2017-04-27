#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionTeleport

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Teleport"
    @docs = "Enter a distant vessel from warp id."

    @target = :warp_id

  end

  def act target = nil, params = ""

    if !target then return @host.answer(:error,"Cannot warp into the void.") end
    if @host.is_locked == true then return @host.answer(:error,"#{@host} is locked.") end

    @host.set_unde(target.id)

    return @host.answer(:modal,"You teleported to #{target}.")

  end

end