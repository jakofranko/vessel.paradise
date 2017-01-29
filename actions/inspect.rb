#!/bin/env ruby
# encoding: utf-8

class ActionInspect

  include Action
  
  def initialize q = nil

    super

    @name = "Inspect"
    @docs = "Get a visible vessel id."

  end

  def act q = "Home"

    target = @host.sibling(q) ; target = target ? target : @host.child(q)
    
    if q.strip == "" then return inventory end
    if !target then return @host.act("look","Cannot find a target named #{q}.") end

    return "<p>You are inspecting #{target}.</p>
    <p>The #{target.name}'s warp id is <action data-action='warp to #{target.id}'>#{target.id}</action>.</p>"
    
  end

  def inventory

    html = "<p>You are inspecting #{@host}.</p>"

    if @host.children.length > 0
      html += "<p>Looking inward, you carry:</p>"

      @host.children.each do |vessel|
        html += vessel.to_s+"<br />"
      end
    end

    if  @host.siblings.length > 0
      html += "<p>Looking outward, you see:</p>"

      @host.siblings.each do |vessel|
        html += vessel.to_s+"<br />"
      end
    end

    return html

  end

end