#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionInspect

  include Action
  
  def initialize q = nil

    super

    @name = "Inspect"
    @docs = "Get a visible vessel id."
    @verb = "Inspecting"
    @target = :visible

  end

  def act params = ""

    target = @host.find_visible(params)

    if !target then target = @host.parent end

    html = "<h3>the #{target}</h3>"
    html += "<h4>General</h4>"
    html += "<p>The #{target}, owned by the #{target.creator}, has the #{target.id} warp id, and a vessel rating of #{target.rating}.</p>"
    html += "<h4>Position</h4>"
    html += "<p>The #{target.name} is currently #{target.depth} levels deep within the #{target.stem} paradox.</p>"

    if target.has_note
      html += "<h4>Note</h4>"
      html += "<p>#{target.note}</p>"
    end
    if target.has_program
      html += "<h4>Program</h4>"
      html += "<code>#{target.program}</code>"
    end

    html += "</table>"

    return html
    
  end

end
