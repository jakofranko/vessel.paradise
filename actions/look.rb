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

    if @host.is_paradox
      return "<p>You are #{@host} paradox.</p>"
    elsif @host.parent.is_paradox
      return "<p>You are #{@host} in #{@host.parent} paradox.</p>"
    elsif @host.parent.parent.is_paradox
      return "<p>You are #{@host} in #{@host.parent.to_s(true,true,false)} of #{@host.parent.parent.to_s(false,true,false)}.</p>"
    end
    return "<p>You are #{@host} in #{@host.parent.to_s(true,true,false)}.</p>"

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
    children = @host.is_paradox ? [] : @host.children
    if children.length == 1
      html += "You carry #{children[0]}. "
    elsif children.length == 2
      html += "You carry #{children[0]} and #{children[1]}. "
    else
      html += ""
    end

    return "<action data-action='inspect ' class='status'></action><p>#{html}</p>"

  end

  def chat

    html = ""

    messages = $forum.to_a("comment")

    count = 0
    messages[messages.length-5,5].each do |message|
      if message.timestamp.elapsed < 100000 then html += message.to_s end
      count += 1
    end

    return "<ul class='forum'>"+html+"</ul>"

  end

  def guide

    hints = []

    # Statuses
    if @host.parent.is_locked then hints.push("The #{@host.parent.name} is locked, you may not modify it.") end
    if @host.parent.is_hidden then hints.push("The #{@host.parent.name} is hidden, you may not see its warp id.") end
    if @host.parent.is_quiet then hints.push("The #{@host.parent.name} is quiet, you may not see other's vessels.") end
    if @host.parent.is_frozen then hints.push("The #{@host.parent.name} is frozen, you may not interact with it.") end

    if hints.length > 0
      return "<ul class='guide code'><li>#{hints.last}</li></ul>"
    end

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