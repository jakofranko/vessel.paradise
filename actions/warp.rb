#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionWarp

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Warp"
    @docs = "Enter a distant vessel from warp id."

    @params = :id

  end

  def act q = "Home"

    target = distant_id(q.split(" ").last.to_i)

    if !target then return @host.act(:look,"Cannot warp into the void.") end
    if @host.is_locked == true then return "<p>#{@host} is locked.</p>" end

    @host.set_unde(target.id)

    return @host.act(:look,"You warped to #{target}.")

  end

end