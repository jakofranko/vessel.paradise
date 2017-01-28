#!/bin/env ruby
# encoding: utf-8

class ActionLook

  include Action
  
  def initialize q = nil

    super

    @name = "Look"
    @docs = "Sight."

  end

  def act q = "Home", answer

    html = answer.to_s != "" ? "<p class='answer'>"+answer+"</p>" : portal
    html += visibles
    html += "<p class='note'>#{@host.parent.note}</p>"
    html += chat
    html += guide

    return html

  end

  def portal

    if @host.parent.id == @host.id
      return "<p>You are in the paradox of a #{@host}.</p>"
    elsif @host.parent.id == @host.parent.unde
      return "<p>You are a #{@host} in the #{@host.parent}.</p>"
    end
    return "<p>"+"You are a #{@host} in the #{@host.parent} of the #{@host.parent.parent.to_s(false)}."+"</p>"

  end

  def visibles

    html = ""
    # Siblings
    siblings = @host.siblings
    if siblings.length == 1
      html += "You see a #{siblings[0]}. "
    elsif siblings.length == 2
      html += "You see a #{siblings[0]} and a #{siblings[1]}. "
    elsif siblings.length > 2
      html += "You see the #{siblings[0]}, the #{siblings[1]} and #{siblings.length-2} other vessels. "
    else
      html += ""
    end

    # Children
    children = @host.children
    if children.length == 1
      html += "You carry a #{children[0]}. "
    elsif children.length == 2
      html += "You carry a #{children[0]} and a #{children[1]}. "
    elsif children.length > 2
      html += "You carry a #{children[0]}, a #{children[1]} and #{children.length-2} other vessels. "
    else
      html += ""
    end

    if siblings.length == 0 && children.length == 0 then html = "There is nothing." end

    return "<action data-action='status ' class='status'><img src='public.paradise/media/vectors/status.svg'/></action>"+"<p>#{html}</p>"

  end

  def chat

    html = ""

    count = 0
    $forum.to_a("comment").reverse.each do |message|
      if count > 3 then break end
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