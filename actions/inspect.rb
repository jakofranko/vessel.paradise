#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionInspect

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Inspect"
    @docs = "Get a visible vessel id."
    @target = :visible

  end

  def act target = nil, params = ""

    if !target then target = @host.parent end

    html = "<p>You are inspecting #{target}.</p>"

    html += "<table>"
    html += "<tr><th>Id</th><td>#{!target.is_hidden ? '≡'+target.id.to_s : '≡'} </td></tr>"
    html += "<tr><th>Name</th><td>#{target.attr} #{target.name}</td></tr>"
    html += "<tr><th>Rank</th><td>+#{target.rank}</td></tr>"
    html += "<tr><th>Value</th><td>$#{target.value}</td></tr>"

    if target.has_program
      html += "<tr><th>Program</th><td>#{target.program}</td></tr>"
    end
    if target.has_note
      html += "<tr><th>Note</th><td>#{target.note}</td></tr>"
    end

    if target.children.length > 0
      html += "<tr><th>Inventory</th><td>"
      target.children.each do |vessel|
        html += "<action data-action='drop the #{vessel.name}'>#{vessel.attr} #{vessel.name} ≡#{vessel.id}</action><br />"
      end
      html += "</td></tr>"
    end

    html += "</table>"

    return html
    
  end

end
