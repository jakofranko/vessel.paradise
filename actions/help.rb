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

  def act q = nil

    if q.to_s.like("actions")
      return help_actions
    elsif q.to_s.like("wildcards")
      return help_wildcards
    else
      return help_default
    end

    return html

  end

  def help_default

    return "<p>Thank you for contacting VHL, the <vessel data-action='warp to 1'>Vessel Help Line</vessel>.<p>What can we help you with today?</p>
    <ul>
      <li><action data-action='help actions'>Actions</action></li>
      <li><action data-action='help wildcards'>Wildcards</action></li>
      <li><action data-action='help programs'>Programs</action></li>
    </ul>
    #{about}"

  end

  def help_actions

    html = "<p>Thank you for contacting VHL, the <vessel data-action='warp to 1'>Vessel Help Line</vessel>.</p>"
    html += "<p>Installed commands for #{@host} vessel. </p>"

    html += "<table>"

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
    html += "</table>"

    return html

  end

  def help_wildcards

    html = "<p>Thank you for contacting VHL, the <vessel data-action='warp to 1'>Vessel Help Line</vessel>.</p>"
    html += "<p>Wildcards are simple functions that can be used in notes and programs. </p>"

    wildcards = [WildcardTime,WildcardRandom,WildcardVessel,WildcardInventory]

    html += "<table>"
    wildcards.each do |wildcard|
      name = wildcard.name.sub('Wildcard','')
      html += "<tr><th>#{name}</th><th colspan='2'>#{wildcard.new.docs}</th><td>"
      wildcard.new.options.each do |option|
        html += "<tr><td></td><td>((<b>#{name.downcase}</b> #{option}))</td><td>#{wildcard.new(@host,option)}</td><td>"
      end
    end
    html += "</table>"

    return html

  end

  def about

    return "<p>Paradise is a multiplayer playground where anyone can become anything and go anywhere. You can learn more about the project on the <a href='http://wiki.xxiivv.com/Paradise' target='_blank'>wiki</a>. </p>"
    
  end

end