#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionSignal

  include Action
  
  def initialize q = nil

    super

    @name = "Signal"
    @verb = "Signaling"
    @docs = "Broadcast your current visible parent vessel."
    @examples = ["signal\n<comment>The black cat signals the yard.</comment>"]

  end

  def act params = ""

    warp_id = params.split(" ").last.to_i
    if warp_id < 1 then return @host.answer(self,:error,"\"#{params}\" is not a valid warp id.") end

    return @host.act("say","#{warp_id}")
    
  end

end