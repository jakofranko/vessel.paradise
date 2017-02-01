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

  end

  def act q = "Home", answer

    html = answer.to_s != "" ? "<p class='answer'>"+answer+"</p>" : portal
    html += note
    html += visibles
    html += chat
    html += guide

    html += "<a class='expand_chat'><img src='public.paradise/media/vectors/chat.svg'/></a>"

    return html

  end

  def portal

    if @host.parent.id == @host.id
      return "<p>You are the paradox of #{@host}.</p>"
    elsif @host.id == @host.parent.unde
      return "<p>You are #{@host} in a paradox of #{@host.parent.to_s(true,true,false)}.</p>"
    elsif @host.parent.id == @host.parent.unde
      return "<p>You are #{@host} in #{@host.parent.to_s(true,true,false)}.</p>"
    end
    return "<p>You are #{@host} in #{@host.parent.to_s(true,true,false)} of #{@host.parent.parent.to_s(false,true,false)}."+"</p>"

  end

  def note

    if !@host.parent.has_note then return "" end

    html = wildcard(@host.parent.note)

    @host.siblings.each do |vessel|
      html = html.sub(" #{vessel.name} "," #{vessel.to_s(false,false)} ")
    end

    return "<p class='note'>#{html}</p>"

  end

  def visibles

    html = ""
    # Siblings
    siblings = @host.siblings
    if siblings.length == 1
      html += "You see #{siblings[0]}. "
    elsif siblings.length == 2
      html += "You see #{siblings[0]} and #{siblings[1]}. "
    elsif siblings.length == 3
      html += "You see #{siblings[0]}, #{siblings[1]} and #{siblings[2]}. "
    elsif siblings.length > 3
      html += "You see #{siblings[0]}, #{siblings[1]} and #{siblings.length-2} other vessels. "
    else
      html += ""
    end

    # Children
    children = @host.is_stem ? [] : @host.children
    if children.length == 1
      html += "You carry #{children[0]}. "
    elsif children.length == 2
      html += "You carry #{children[0]} and #{children[1]}. "
    elsif children.length == 3
      html += "You carry #{children[0]}, #{children[1]} and #{children[2]}. "
    elsif children.length > 3
      html += "You carry #{children[0]}, #{children[1]} and #{children.length-2} other vessels. "
    else
      html += ""
    end

    if siblings.length == 0 && children.length == 0 then html = "There is nothing." end

    return "<action data-action='inspect ' class='status'><img src='public.paradise/media/vectors/status.svg'/></action>"+"<p>#{html}</p>"

  end

  def chat

    html = ""

    messages = $forum.to_a("comment")

    count = 0
    messages[messages.length-8,8].each do |message|
      if count > 7 then break end
      html += message.to_s
      count += 1
    end

    return "<ul class='forum'>"+html+"</ul>"

  end

  def guide

    if @host.parent.owner != @host.id then return "" end

    html = ""

    if !@host.parent.has_note then html += "<li>Add a <action data-action='note '>note</action> to the parent vessel.</li>" end
    if !@host.parent.has_attr then html += "<li>Add an <action data-action='rename '>attribute</action> to the parent vessel.</li>" end

    return "<ul class='guide'>#{html}</ul>"

  end

end