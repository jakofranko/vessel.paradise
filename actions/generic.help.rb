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

  def act target = nil, params = ""

    if params.to_s.like("actions")
      return help_actions
    elsif params.to_s.like("wildcards")
      return help_wildcards
    elsif params.to_s.like("programs")
      return help_programs
    else
      return help_default
    end

    return html

  end

  def help_default

    html = "<p>Thank you for contacting VHL, the <vessel data-action='warp to 1'>Vessel Help Line</vessel>.<p>What can we help you with today?</p>
    <ul>
      <li><action data-action='help actions'>Actions</action></li>
      <li><action data-action='help wildcards'>Wildcards</action></li>
      <li><action data-action='help programs'>Programs</action></li>
    </ul>
    #{about}"

    red = 0
    cyan = 0

    $parade.each do |vessel|
      if vessel.attr == "red" then red += 1 end
      if vessel.attr == "cyan" then cyan += 1 end
    end

    if red > cyan
      html += "<p>The Red Spawn is winning with <b>#{(red/(cyan+red).to_f * 100).to_i}% control</b> over #{$parade.length} vessels.</p>"
    else
      html += "<p>The Cyan Mass is winning with <b>#{(cyan/(cyan+red).to_f * 100).to_i}% control</b> over #{$parade.length} vessels.</p>"
    end

    return html

  end

  def help_actions

    html = "<p>Thank you for contacting VHL, the <vessel data-action='warp to 1'>Vessel Help Line</vessel>.</p>"
    html += "<p>Installed commands for #{@host} vessel. </p>"

    html += "<ul class='index'>"
    @host.actions.each do |cat,actions|
      if cat == :generic then next end
      html += "<li>#{cat.capitalize}</li>"
      html += "<ul>"
      actions.each do |action|
        action = action.new
        html += "<li>#{action.name.capitalize}</li>"
      end
      html += "</ul>"
    end
    html += "</ul>"

    @host.actions.each do |cat,actions|
      if cat == :generic then next end
      html += "<h3>#{cat.capitalize}</h3>"
      actions.each do |action|
        action = action.new
        html += "<h4>#{action.name.capitalize}</h4>"
        action.examples.each do |example|
          html += "<code>#{example}</code>"
        end
        html += "<p>#{action.docs}</p>"
      end
    end

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

  def help_programs

    html = "<p>Thank you for contacting VHL, the <vessel data-action='warp to 1'>Vessel Help Line</vessel>.</p>"
    html += "<p>Programs are simple automations that can be added onto vessels. </p>"

    html += "<table>
    <tr><th>Warp</th><td>warp to 10</td></tr>
    <tr><th></th><td>warp to ((random 3,4,5))</td></tr>

    <tr><th>Talkers</th><td>say hello</td></tr>
    <tr><th></th><td>say time is ((time hour)):((time minute)).</td></tr>
    </table>"

    return html

  end

  def about

    return "<p>Paradise is a multiplayer playground where anyone can become anything and go anywhere. You can learn more about the project on the <a href='http://wiki.xxiivv.com/Paradise' target='_blank'>wiki</a>. </p>"
    
  end

end