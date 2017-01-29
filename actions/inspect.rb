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

    html = "<p>You are inspecting #{@host.parent}.</p>"

    if @host.children.length > 0
      html += "<table><tr><th>≡#{@host.id}</th><th>Inventory</th></tr>"
      @host.children.each do |vessel|
        html += "<tr><td>≡#{vessel.id}</td><td>"+vessel.to_s+"</td></tr>"
      end
      html += "</table>"
    end

    if @host.siblings.length > 0 && !@host.is_stem
      html += "<table><tr><th>≡#{@host.parent.id}</th><th>#{@host.parent}</th></tr>"
      @host.siblings.each do |vessel|
        html += "<tr><td>≡#{vessel.id}</td><td>"+vessel.to_s+"</td></tr>"
      end
      html += "</table>"
    end

    return html
    
  end

end