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

    html = "<p>You are inspecting #{@host}, in #{@host.parent}.</p>"

    if @host.children.length > 0
      html += "<table><tr><th>≡#{@host.id}</th><th>Inventory</th></tr>"
      @host.children.each do |vessel|
        html += "<tr><td>≡#{vessel.id}</td><td>"+vessel.to_s+"</td></tr>"
      end
      html += "</table>"
    end

    if  @host.siblings.length > 0
      html += "<table><tr><th>≡#{@host.parent.id}</th><th>Visible</th></tr>"
      @host.siblings.each do |vessel|
        html += "<tr><td>≡#{vessel.id}</td><td>"+vessel.to_s+"</td></tr>"
      end
      html += "</table>"
    end

    return html

  end

end