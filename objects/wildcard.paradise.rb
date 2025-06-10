#!/bin/env ruby
require_relative 'wildcard'

# Display information about Paradise itself
class WildcardParadise

  include Wildcard

  def initialize(host = nil, value = nil)

    super

    @docs = 'Displays paradise core layouts.'
    @options = %w[paradoxes spells glossary tunnels]

  end

  def to_s

    return paradoxes if @value.like('paradoxes')
    return spells if @value.like('spells')
    return glossary if @value.like('glossary')
    return tunnels if @value.like('tunnels')

    # Secrets
    return train_stations if @value.like('train_stations')
    return cyan_count if @value.like('cyan count')
    return red_count if @value.like('red count')
    return cyan_list if @value.like('cyan list')
    return red_list if @value.like('red list')

    '?'

  end

  def paradoxes

    html = ''

    $nataniev.vessels[:paradise].parade.each do |vessel|

      next unless vessel.is_paradox
      next unless vessel.is_locked
      next if vessel.is_hidden
      next if vessel.memory_index < 1
      next if vessel.rating < 50

      mi = vessel.memory_index
      a = vessel.attr.capitalize
      n = vessel.name.capitalize
      owner = vessel.owner != 0 ? ", by the #{vessel.creator}" : ''
      html += "<li><action-link data-action='warp to #{mi}'>#{a} #{n}</action-link>#{owner}</li>"

    end

    "<ul class='basic'>#{html}</ul>"

  end

  def spells

    html = ''

    $nataniev.vessels[:paradise].parade.each do |vessel|

      next unless vessel.has_program
      next unless vessel.is_locked
      next unless vessel.has_attr
      next unless vessel.name.like('spell')

      a = vessel.attr
      n = vessel.name
      owner = vessel.owner != 0 ? ", by the #{vessel.creator}" : ''
      al = "<action-link data-action='cast the #{a} #{n}'>#{a.capitalize} #{n.capitalize}</action-link>"
      html += "<li>#{al}#{owner}</li>"

    end

    "<ul class='basic'>#{html}</ul>"

  end

  def tunnels

    html = ''

    $nataniev.vessels[:paradise].tunnels.each do |vessel|

      next unless vessel.is_tunnel
      next if vessel.is_hidden
      next if vessel.memory_index == @host.parent.memory_index
      next if vessel.rating < 50

      mi = vessel.memory_index
      a = vessel.attr.capitalize
      n = vessel.name.capitalize
      owner = vessel.owner != 0 ? ", by the #{vessel.creator}" : ''
      html += "<li><action-link data-action='warp to #{mi}'>#{a} #{n}</action-link>#{owner}</li>"

    end

    "<ul class='basic'>#{html}</ul>"

  end

  def train_stations

    html = ''

    $nataniev.vessels[:paradise].parade.each do |vessel|

      next if vessel.is_hidden
      next unless vessel.has_note
      next unless vessel.is_locked
      next unless vessel.note.include?('train station')
      next if vessel.memory_index == @host.parent.memory_index

      mi = vessel.memory_index
      a = vessel.attr.capitalize
      n = vessel.name.capitalize
      owner = vessel.owner != 0 ? ", by the #{vessel.creator}" : ''
      html += "<li><action-link data-action='warp to #{mi}'>#{a} #{n}</action-link>#{owner}</li>"

    end

    "<ul class='basic'>#{html}</ul>"

  end

  def glossary

    g = {}

    g[:general] = {}
    g[:general]['a vessel'] = 'is a pocket of conceptspace with an attribute and a name, able to traverse Paradise.'
    g[:general]['a paradox'] = 'is impossible space folded onto itself, and stems to universes. '
    g[:general]['a tunnel'] = 'is a vessel or action type accessible across all space. '\
      'Cast and Warp are tuneling actions, allowing ghosts to traverse vast distances instantly. '\
      'A tuneling vessel will be accessible through notes across distances.'
    g[:general]['a signal'] = 'is the broadcasting of a warp id.'
    g[:general]['the parade'] = "is another name for all of Paradise's activity."
    g[:general]['the haven'] = 'is a tutorial region with various documentation vessels.'

    g[:void] = {}
    g[:void]['the void'] = 'is generic unbuilt vessel space, any warp id that is yet unused.'
    g[:void]['the ultravoid'] = 'is the hyptothesized vessel space of negative warp id.'

    g[:factions] = {}
    g[:factions]['cyan mass'] = 'is the sum of the cyan vessels.'
    g[:factions]['red spawn'] = 'is the sum of the red vessels.'

    g[:fashion] = {}
    g[:fashion]['thingspace'] = 'is a type of vessels with eucledian and real-world attributes. '\
      'Often the default simplistic mindset of new players.'
    g[:fashion]['conceptspace'] = 'is a type of vessels with non-spacial attributes, '\
      'or hard to visualize attributes. '\
      'It has been suggested that the Parade is a research project exploring the limits of conceptspace.'
    g[:fashion]['illegalspace'] = 'is a type of vessels with non-paradise attributes, '\
      'often the result of exploits. A vessel with a number for a name, for instance.'

    html = ''
    g.each do |cat, terms|

      html += "<h4>#{cat}</h4>"
      html += "<ul class='basic' style='margin-bottom:30px'>"
      terms.each do |term, definition|

        html += "<li><b>#{term.capitalize}</b>, #{definition}</li>"

      end
      html += '</ul>'

    end
    html

  end

  def cyan_count

    count = 0
    $nataniev.vessels[:paradise].parade.each do |vessel|

      count += 1 if vessel.attr.like('cyan')

    end

    "<span class='cyan'>#{count}</span>"

  end

  def red_count

    count = 0
    $nataniev.vessels[:paradise].parade.each do |vessel|

      count += 1 if vessel.attr.like('red')

    end

    "<span class='red'>#{count}</span>"

  end

  def cyan_list

    html = "<ul class='cyan basic'>"
    $nataniev.vessels[:paradise].parade.each do |vessel|

      html += "<li>#{vessel}</li>" if vessel.attr.like('cyan')

    end

    html += '</ul>'
    html

  end

  def red_list

    html = "<ul class='red basic'>"
    $nataniev.vessels[:paradise].parade.each do |vessel|

      html += "<li>#{vessel}</li>" if vessel.attr.like('red')

    end

    html += '</ul>'
    html

  end

end
