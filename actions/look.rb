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

    return html

  end

  def portal

    if @host.parent.id == @host.id
      return "<p>You are the paradox of #{@host}.</p>"
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
    else
      html += ""
    end

    if siblings.length == 0 then html = "You see nothing." end

    return "<action data-action='inspect ' class='status'><img src='public.paradise/media/vectors/status.svg'/></action>"+"<p>#{html}</p>"

  end

  def chat

    html = ""

    messages = $forum.to_a("comment")

    count = 0
    messages[messages.length-7,7].each do |message|
      if message.timestamp.elapsed < 100000 then html += message.to_s end
      count += 1
    end

    return "<ul class='forum'>"+html+"</ul>"

  end

  def guide

    hints = []

    # Check Validity
    validity_check, validity_errors = @host.is_valid
    if validity_check == false then hints += validity_errors end
    validity_check, validity_errors = @host.parent.is_valid
    if validity_check == false then hints += validity_errors end

    if hints.length > 0
      html = ""
      hints.each do |hint|
        html += "<li>#{hint}</li>"
      end
      return "<ul class='guide alert'>#{html}</ul>"
    end

    # Own's
    if @host.parent.owner == @host.id
      hints.push("Vessel is complete.")
      if !@host.parent.has_note then hints.push("Add a <action data-action='note '>note</action> to the parent vessel.") end
      if !@host.parent.has_attr then hints.push("Add an <action data-action='make '>attribute</action> to the parent vessel.") end
    # Improvements
    elsif !@host.parent.is_locked
      if !@host.parent.has_note then hints.push("Improve this vessel with a <action data-action='note '>note</action>.") end
      if !@host.parent.has_attr then hints.push("Improve this vessel with an <action data-action='make '>attribute</action>.") end
    end

    # All good!
    if hints.length < 1 then return "" end

    html = ""
    hints.each do |hint|
      html += "<li>#{hint}</li>"
    end
    return "<ul class='guide'>#{html}</ul>"

  end

end