#!/bin/env ruby
# encoding: utf-8

class ActionHelp

  include Action
  
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

    return html

  end

  def list_actions

    html = ""
    @host.actions.each do |cat,actions|
      html += "<tr><th colspan='2'>#{cat}</th></tr>"
      actions.each do |action|
        action = action.new
        html += "<tr><td>#{action.name}</td><td>#{action.docs}</td></tr>"
      end
    end
    return "<table>#{html}</table>"

  end

end