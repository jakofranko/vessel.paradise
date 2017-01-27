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

    html  = answer.to_s != "" ? "<p class='answer'>"+answer+"</p>" : portal
    html += visibles
    html += "<p class='note'>#{@host.parent.note}</p>"
    html += guide

    return html

  end

  def portal

    if @host.parent.unde == @host.parent.parent.unde
      return "<p>"+"You are a #{@host} in the #{@host.parent}."+"</p>"
    end
    return "<p>"+"You are a #{@host} in the #{@host.parent} of a #{@host.parent.parent.to_s(false)}."+"</p>"

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

    return "<p>#{html}</p>"

  end

  def guide

    if @host.parent.owner != @host.id then return "" end

    return "<p class='guide'>Guide</p>"

  end

end