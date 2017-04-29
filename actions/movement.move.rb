#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionMove

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Move"
    @docs = "Become related to the target visible vessel with a custom relationship word."
    @examples = ["move under the carpet\n<comment>The black cat is under the carpet.</comment>"]

  end

  def act target = nil, params = ""

    name = params.split(" ").last.strip
    target = @host.find_visible(name)
    if !target then return @host.answer(:error,"#{@host} could not move there.") end

    link = params.sub(target.name,"")
    link = link.sub(target.attr,"")

    if name.like(link) then link = "in" end    

    @host.set_unde(target.id,link)

    return @host.answer(:modal,"#{@host.to_s(true,true,false,false).capitalize} moved #{link} #{target.to_s(true,true,false,false)}.")
    
  end

end