#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionLook

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Look"
    @docs = "Sight."
    @verb = "Looking"

  end

  def act target = nil, params = ""

    return "
    #{portal}
    #{page}
    #{note}
    #{default}
    #{action}
    #{chat}
    #{guide}"

  end

  def portal

    html = ""
    if @host.is_paradox
      html = "#{@host} Paradox"
    elsif @host.parent.is_paradox
      html = "#{@host.parent}"
    else
      html = "#{@host} in #{@host.parent.to_s(true,true,false)}"
    end
    return "<h1 id='portal'>#{html}</h1>"    

  end

  def page

    return "<h2 id='page'>#{@host.parent.is_hidden ? '≡' : @host.parent.id}</h2>"

  end

  def note

    if !@host.parent.has_note then return "" end

    html = @host.parent.note.wildcards(@host)
    html = html.gsub(".. ",". <br /><br />")
    html = html.gsub(":. ",": <br /><br />")
    html = html.gsub("?. ","? <br /><br />")
    html = html.gsub(",. ",", <br /><br />")
    html = parse_vessels_in_note(html)

    return "<p id='note'>#{html}</p>"

  end

  def default

    html = ""

    if @host.siblings.length == 1
      html += "You see #{@host.siblings[0]}. "
    elsif @host.siblings.length == 2
      html += "You see #{@host.siblings[0]} and #{@host.siblings[1]}. "
    elsif @host.siblings.length == 3
      html += "You see #{@host.siblings[0]}, #{@host.siblings[1]} and #{@host.siblings[2]}. "
    elsif @host.siblings.length > 3
      html += "You see #{@host.siblings[0]}, #{@host.siblings[1]} and #{@host.siblings.length-2} other vessels. "
    elsif !@host.parent.is_silent && !@host.parent.has_note
      html += "There is nothing here, why don't you create something."
    end

    return "<p>#{html}</p>"

  end


  def action

    @host.siblings.each do |vessel|
      if vessel.has_program then return "<p id='action'><vessel data-action='use #{vessel.to_s(true,true,false,false)}'>Use #{vessel.to_s(true,true,false,false)}.</vessel></p>" end
    end

    return ""

  end


  def parse_vessels_in_note html

    html = html.gsub(","," , ")
    html = html.gsub("."," . ")

    @host.siblings.each do |vessel|
      html = html.sub(" #{vessel.name} "," #{vessel.to_s(false,false,true,true)} ")
    end
    @host.tunnels.each do |vessel|
      html = html.sub(" #{vessel.attr} #{vessel.name} "," <vessel class='tunnel' data-action='warp to the #{vessel.attr} #{vessel.name}'>#{vessel.attr} #{vessel.name}</vessel> ")
    end

    html = html.gsub(" , ",", ")
    html = html.gsub(" . ",". ")

    return html

  end

  def parse_wildcards text

    text.scan(/(?:\(\()([\w\W]*?)(?=\)\))/).each do |str,details|
      key = str.split(" ").first
      value = str.sub("#{key} ","").strip
      if Kernel.const_defined?("Wildcard#{key.capitalize}")
        wc = Object.const_get("Wildcard#{key.capitalize}").new(@host,value)
        text = text.gsub("((#{str}))",wc.to_s)
      else
        text = text.gsub(str,"Error:#{key}.")
      end
    end

    return text

  end

  def chat

    html = ""

    if @host.parent.is_silent then return "" end

    messages = $forum.to_a("comment")

    selection = @host.parent.name.like("lobby") ? messages[messages.length-7,7] : messages[messages.length-3,3]

    selection.each do |message|
      html += message.to_s
    end

    return "<ul id='forum'>"+html+"</ul>"

  end

  def guide

    html = ""

    id = 1
    @host.parent.guides.each do |guide|
      html += "<li><b>#{id}.</b> #{guide} </li>"
      id += 1
    end

    return "<ul id='guide'>#{html}</ul>"

  end

end