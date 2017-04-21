#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionCall

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Call"
    @docs = "Call a distant program."

    @params = :id

  end

  def act q = "Home"

    return "HYE"
    
    target = distant_id(q.split(" ").last.to_i)

    if !target then return @host.answer(:error,"Cannot warp into the void.") end
    if @host.is_locked == true then return @host.answer(:error,"#{@host} is locked.") end

    @host.set_unde(target.id)

    return @host.answer(:modal,"You warped to #{target}.")

  end

end