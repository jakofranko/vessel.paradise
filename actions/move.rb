#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionMove

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Move"
    @docs = "Move around."

    @target = :self

  end

  def act target = nil, params = ""

    name = params.split(" ").last.strip
    link = params.split(" ").first.strip
    if name.like(link) then link = "in" end

    target = @host.find_visible(name)

    if !target then return @host.answer(:error,"#{@host} could not move there.") end

    @host.set_unde(target.id,link)

    return @host.answer(:modal,"#{@host} moved #{link} #{target}.","Your warp id is now visible to other players.")
    
  end

end