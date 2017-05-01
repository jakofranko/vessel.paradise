#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionWarp

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Warp"
    @verb = "Warping"
    @docs = "Enter a distant vessel by either its name, or its warp id. The vessel must be visible."
    @examples = ["warp to the library\n<comment>The black cat is in the library.</comment>",
      "warp to 1\n<comment>The black cat is in the library.</comment>"]

  end

  def act target = nil, params = ""

    target = @host.find_distant(params)
    prev = @host.parent

    if params.split(" ").last.to_i < 0 then return @host.answer(self,:error,"#{topic} may not travel in negative space.") end
    if !target then return @host.answer(self,:error,"#{topic} cannot warp into the void.") end
    if target.id == @host.parent.id then return @host.answer(self,:error,"#{topic} already are in #{target.to_s(true,true,false,false)}.") end
    if @host.is_locked == true then return @host.answer(self,:error,"#{topic} are locked.") end

    @host.set_unde(target.id)

    return @host.answer(self,:modal,"#{topic} left #{prev.to_s(true,true,false,false)} and warped to #{target.to_s(true,true,false,false)}.")

  end

end