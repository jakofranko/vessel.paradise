#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionLook

  include Action

  def initialize q = nil

    super

    @name = "Look"
    @docs = "Sight."
    @verb = "Looking"

  end

  def act params = ""

    return "
    #{portal}
    #{page}
    #{note}
    #{default}
    #{action}
    #{guide}"

  end

  def portal

    html = ""

    if @host.is_paradox
      html = "You are a paradox of the <span id='attr' class='#{@host.attr}'>#{@host}</span>."
    elsif @host.parent.is_paradox
      html = "You are the <span id='attr' class='#{@host.attr}'>#{@host}</span>, in #{@host.parent.owner == @host.memory_index ? 'your' : 'the'} #{@host.parent} Paradox."
    else
      html = "You are the <span id='attr' class='#{@host.attr}'>#{@host}</span>, in #{@host.parent.owner == @host.memory_index ? 'your' : 'the'} #{@host.parent}."
    end

    return "<h1 id='portal'>#{html}</h1>"

  end

  def page

    return "<h2 id='page'>#{@host.parent.is_hidden ? '≡' : '<action-link data-action="inspect">' + @host.parent.memory_index.to_s + '</action-link>'}</h2>"

  end

  def note

    if !@host.parent.has_note then return "" end

    html = parse_vessels_in_note(@host.parent.note)
    html = parse_wildcards(html)
    html = html.gsub(".. ",". <br /><br />")
    html = html.gsub(":. ",": <br /><br />")
    html = html.gsub("?. ","? <br /><br />")
    html = html.gsub(",. ",", <br /><br />")

    return "<p id='note'>#{html}</p>"

  end

  def default

    filtered_siblings = @host.siblings.filter {|vessel| @host.parent.note.include?(vessel.to_s) == false}

    html = ""

    if filtered_siblings.length == 1
      html += "You see the #{filtered_siblings[0].to_html}. "
    elsif filtered_siblings.length == 2
      html += "You see the #{filtered_siblings[0].to_html} and the #{filtered_siblings[1].to_html}. "
    elsif filtered_siblings.length == 3
      html += "You see the #{filtered_siblings[0].to_html}, the #{filtered_siblings[1].to_html} and the #{filtered_siblings[2].to_html}. "
    elsif filtered_siblings.length > 3
      html += "You see the #{filtered_siblings[0].to_html}, the #{filtered_siblings[1].to_html} and <action-link data-action='inspect'>#{filtered_siblings.length-2} other vessels</action-link>. "
    elsif !@host.parent.is_silent && !@host.parent.has_note
      html += "<i style='color:#999'>There is nothing here, why don't you <action-link data-action='create '>create</action-link> something.</i>"
    end

    return "<p>#{html}</p>"

  end


  def action

    @host.siblings.each do |vessel|
      if vessel.has_program then return "<p id='action'><vessel-link data-action='use the #{vessel}'>Use the #{vessel}.</vessel-link></p>" end
    end

    return ""

  end


  def parse_vessels_in_note html

    parsed_vessels = []

    $nataniev.vessels[:paradise].tunnels.each do |vessel|
      action_override = "warp to #{vessel.memory_index}"
      class_override  = "tunnel"
      html = html.sub("#{vessel.attr} #{vessel.name}", "#{vessel.to_html(action_override, class_override)}")
      parsed_vessels.append(vessel.to_s)
    end

    @host.siblings.each do |vessel|
      if parsed_vessels.include?(vessel.to_s) then next end
      html = html.sub("#{vessel.has_attr ? vessel.attr + ' ' : ''}#{vessel.name}", "#{vessel.to_html}")
      parsed_vessels.append(vessel.to_s)
    end

    return html

  end

  def parse_wildcards text

    text.scan(/(?:\(\()([\w\W]*?)(?=\)\))/).each do |str, details|
      key = str.split(" ").first
      value = str.sub("#{key} ", "").strip
      if Kernel.const_defined?("Wildcard#{key.capitalize}")
        wc = Object.const_get("Wildcard#{key.capitalize}").new(@host, value)
        text = text.gsub("((#{str}))", wc.to_s)
      else
        text = text.gsub(str, "Error: #{key}.")
      end
    end

    return text

  end

  def guide

    html = ""

    guides = @host.parent.guides

    id = 1
    guides.each do |guide|
      html += "<li><b>#{id}.</b> #{guide} </li>"
      id += 1
    end

    return guides.length > 0 ? "<ul id='guide'>#{html}</ul>" : ""

  end

end
