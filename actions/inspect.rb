#!/bin/env ruby
# encoding: utf-8

class ActionInspect

  include Action
  
  def initialize q = nil

    super

    @name = "Inspect"
    @docs = "TODO"

  end

  def act q = "Home"

    target = @host.sibling(q) ; target = target ? target : @host.child(q)
    
    if q.strip == "" then return inventory end
    if !target then return @host.act("look","Cannot find a target named #{q}.") end

    return "You inspect #{target}. "
    
  end

  def inventory

    html = ""

    html += "<p>Looking inward, you are carrying the following vessels.</p>"

    @host.children.each do |vessel|
      html += vessel.to_s+"<br />"
    end

    return html

  end

end