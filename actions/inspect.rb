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

    html += "<table>"
    html += "<tr><th>Full name</th><td>#{@host.parent.attr} #{@host.parent.name}</td></tr>"
    html += "<tr><th>Id</th><td>≡#{@host.parent.id} </td></tr>"
    html += "<tr><th>Rank</th><td>#{@host.parent.rank}</td></tr>"

    if @host.parent.has_program
      html += "<tr><th>Program</th><td>#{@host.parent.program}</td></tr>"
    end

    if @host.siblings.length > 0
      html += "<tr><th>Inventory<td>"
      @host.siblings.each do |vessel|
        html += "<action data-action='enter the #{vessel.name}'>#{vessel.attr} #{vessel.name} ≡#{vessel.id}</action></br />"
      end
      html += "</td></tr>"
    end

    html += "</table>"

    return html
    
  end

end