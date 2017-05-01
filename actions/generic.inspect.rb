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
    @verb = "Inspecting"
    @target = :visible

  end

  def act params = ""

    target = @host.find_visible(params)

    if !target then target = @host.parent end

    html = "<h3>Inspecting the #{target.name}</h3>"
    html += "<table>"
    html += "<tr><th>Main</th><td>The #{target.attr} #{target.name} #{!target.is_hidden ? '≡ '+target.id.to_s : '≡'} </td></tr>"
    html += "<tr><th>Owner</th><td>#{target.creator.to_s(true,true,false,false)}</td></tr>"
    html += "<tr><th>Rating</th><td>#{target.rating}</td></tr>"
    html += "<tr><th>Permissions</th><td>#{target.perm}</td></tr>"

    if target.has_program
      html += "<tr><th>Program</th><td><code>#{target.program}\n#{target.program.to_s.include?("((") ? target.program.render : ''}</code></td></tr>"
    end
    if target.has_note
      html += "<tr><th>Note</th><td><p>#{target.note}</p></td></tr>"
    end

    if target.children.length > 0
      html += "<tr><th>#{target.children.length} Children</th><td>"
      target.children.each do |vessel|
        html += "#{vessel}<br/>"
      end
      html += "</td></tr>"
    end

    html += "</table>"

    return html
    
  end

end
