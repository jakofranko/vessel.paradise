#!/bin/env ruby
require_relative 'wildcard'

# For listing a vessel's children
class WildcardChildren

  include Wildcard

  def initialize(host = nil, value = nil)

    super

    @docs = "Display children vessels. Its purpose is to access the current vessel's inventory."
    @options = %w[count random]

  end

  def to_s

    return @host.children.length.to_s if @value.like('count')
    return '' if @host.children.empty?
    return @host.children.sample.name if @value.like('random')
    return list if @value.like('list')

    ''

  end

  def list

    html = ''

    @host.children.each do |vessel|

      owner = vessel.owner != 0 ? ", by the #{vessel.creator}" : ''
      a = vessel.attr
      n = vessel.name
      al = "<action-link data-action='cast the #{a} #{n}'>#{a.capitalize} #{n.capitalize}</action-link>"
      html += "<li>#{al}#{owner}</li>"

    end

    "<ul class='basic'>#{html}</ul>"

  end

end
