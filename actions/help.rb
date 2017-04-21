#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionHelp

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Help"
    @docs = "List commands."

  end

  def act q = "Home"

    html = ""
    html += "<p>Thank you for contacting the vessel help line.</p>"
    html += "<p>Installed commands for #{@host} vessel. </p>"

    html += list_actions

    html += about

    return html

  end

  def list_actions

    html = ""
    @host.actions.each do |cat,actions|
      if cat == :generic then next end
      html += "<tr><th>#{cat.capitalize}</th><td>"
      actions.each do |action|
        action = action.new
        html += "<b>#{action.name}</b> "
        if action.target then html += "<span class='target'>#{action.target}</span> " end
        if action.params then html += "<span class='params'>#{action.params}</span> " end
        html += "<br />"
      end

      html += "</td></tr>"
      
    end
    return "<table>#{html}</table>"

  end

  def about

    return "<p>Paradise is a multiplayer playground where anyone can become anything and go anywhere. You can learn more about the project on the <a href='http://wiki.xxiivv.com/Paradise' target='_blank'>wiki</a>. </p>"
    
  end

end