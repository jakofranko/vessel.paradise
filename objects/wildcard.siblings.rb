#!/bin/env ruby
require_relative 'wildcard'

# For fetching vessels in the same parent
class WildcardSiblings

  include Wildcard

  def initialize(host = nil, value = nil)

    super

    @docs = 'Display sibling vessels.'
    @options = %w[count random]

  end

  def to_s

    return @host.siblings.length.to_s if @value.like('count')
    return '' if @host.siblings.empty?
    return @host.siblings.sample.name if @value.like('random')
    return list if @value.like('list')

    ''

  end

  def list

    html = ''

    @host.siblings.each do |vessel|

      a = vessel.attr
      n = vessel.name
      owner = vessel.owner != 0 ? ", by the #{vessel.creator}" : ''
      al = "<action-link  data-action='cast the #{a} #{n}'>#{a.capitalize} #{n.capitalize}</action-link>"
      html += "<li>#{al}#{owner}</li>"

    end

    "<ul class='basic'>#{html}</ul>"

  end

end
