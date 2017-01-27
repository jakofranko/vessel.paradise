#!/bin/env ruby
# encoding: utf-8

class ActionLook

  include Action
  
  def initialize q = nil

    super

    @name = "Look"
    @docs = "Sight."

  end

  def act q = "Home"

    html  = "<p>"+"You are a #{@host} in the #{@host.parent} of a #{@host.parent.parent}."+"</p>"
    html += visibles
    html += "<p class='note'>"+@host.parent.note+"</p>"
    html += guide

    return html

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
      html += "You are carrying a #{children[0]}. "
    elsif children.length == 2
      html += "You are carrying a #{children[0]} and a #{children[1]}. "
    elsif children.length > 2
      html += "You are carrying the #{children[0]}, the #{children[1]} and #{children.length-2} other vessels. "
    else
      html += ""
    end

    return "<p>#{html}</p>"

  end

  def guide

    return "<p class='guide'>Guide</p>"

  end

end