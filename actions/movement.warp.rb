#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionWarp

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Warp"
    @docs = "Enter a distant vessel by either its name, or its warp id. The vessel must be visible."
    @examples = ["warp to the library\n<comment>The black cat is in the library.</comment>",
      "warp to 1\n<comment>The black cat is in the library.</comment>"]

  end

  def act target = nil, params = ""

    target = @host.find_distant(params)

    if !target then return @host.answer(:error,"Cannot warp into the void.") end
    if @host.is_locked == true then return @host.answer(:error,"#{@host} is locked.") end

    @host.set_unde(target.id)

    return @host.answer(:modal,"You warped to #{target}.")

  end

end