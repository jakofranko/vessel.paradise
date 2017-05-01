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

  def act params = ""

    target = params.split(" ").last.to_s

    @wildcards = [WildcardTime,WildcardRandom,WildcardVessel,WildcardChildren,WildcardSiblings]

    if target.like("wildcards") then return help_wildcards end
    if target.like("attributes") then return help_attributes end
    if @host.actions[target.to_sym] then return help_action(target.to_sym) end

    return help_default

  end

  def help_default

    html = "<p>Thank you for contacting VHL, the <vessel data-action='warp to 1'>Vessel Help Line</vessel>."

    html += topics
    html += about
    html += factions

    return html

  end

  def topics

    html = "<h3>Topics</h3>"
    html += "<ul id='index'>"

    # Actions
    @host.actions.each do |cat,actions|
      if cat == :generic then next end
      html += "<li><action data-action='help with #{cat}'>#{cat.capitalize}</action></li>"
      html += "<ul>"
      actions.each do |action|
        action = action.new
        html += "<li>#{action.name.capitalize}</li>"
      end
      html += "</ul>"
    end

    # Wildcards
    html += "<li><action data-action='help with wildcards'>Wildcards</action></li>"
    html += "<ul>"
    @wildcards.each do |wildcard|
      name = wildcard.name.sub('Wildcard','')
      html += "<li>#{name}</li>"
    end
    html += "</ul>"

    # Attributes

    html += "<li><action data-action='help with attributes'>Attributes</action></li>"
    html += "<ul>"
    ["Locked","Hidden","Silent","Tunnel"].each do |attribute|
      html += "<li>#{attribute}</li>"
    end
    html += "</ul>"

    html += "</ul>"

    return html

  end

  def factions

    html = ""

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

  def help_action cat

    html = ""

    html += "<h3>#{cat.capitalize}</h3>"
    @host.actions[cat].each do |action|
      action = action.new
      html += "<h4>#{action.name.capitalize}</h4>"
      action.examples.each do |example|
        html += "<code>#{example}</code>"
      end
      html += "<p>#{action.docs}</p>"
    end

    return html

  end

  def help_wildcards


    html = "<h3>Wildcards</h3>"

    @wildcards.each do |wildcard|
      name = wildcard.name.sub('Wildcard','')
      html += "<h4>#{name}</h4>"
      html += "<code>"
      wildcard.new.options.each do |option|
        html += "((<b>#{name.downcase}</b> #{option})) <comment>#{wildcard.new(@host,option)}</comment>\n"
      end
      html += "</code>"
      html += "<p>#{wildcard.new.docs}</p>"
    end

    return html

  end

  def help_attributes

    return "<p>Coming soon.</p>"

  end

  def about

    return "
    <h4>About</h4><p>Paradise is a multiplayer playground exploring the limits of thingspace and conceptspace. You can learn more about the project on the <a href='http://wiki.xxiivv.com/Paradise' target='_blank'>wiki</a>. </p>"
    
  end

end