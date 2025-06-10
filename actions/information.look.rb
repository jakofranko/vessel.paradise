#!/bin/env ruby
require_relative '_toolkit'

# The default action in paradise...
class ActionLook

  include Action

  def initialize(q = nil)

    super

    @name = 'Look'
    @docs = 'Sight.'
    @verb = 'Looking'

  end

  def act(_params = '')

    "
    #{portal}
    #{page}
    #{note}
    #{default}
    #{action}
    #{guide}"

  end

  def portal

    html = if @host.is_paradox
             "You are a paradox of the <span id='attr' class='#{@host.attr}'>#{@host}</span>."
           elsif @host.parent.is_paradox
             "You are the <span id='attr' class='#{@host.attr}'>#{@host}</span>, "\
             "in #{@host.parent.owner == @host.memory_index ? 'your' : 'the'} #{@host.parent} Paradox."
           else
             "You are the <span id='attr' class='#{@host.attr}'>#{@host}</span>, "\
             "in #{@host.parent.owner == @host.memory_index ? 'your' : 'the'} #{@host.parent}."
           end

    "<h1 id='portal'>#{html}</h1>"

  end

  def page

    p = @host.parent
    h2 = p.is_hidden ? '≡' : "<action-link data-action='inspect'>#{p.memory_index}</action-link>"

    "<h2 id='page'>#{h2}</h2>"

  end

  def note

    return '' unless @host.parent.has_note

    html = parse_vessels_in_note(@host.parent.note)
    html = parse_wildcards(html)
    html = html.gsub('.. ', '. <br /><br />')
    html = html.gsub(':. ', ': <br /><br />')
    html = html.gsub('?. ', '? <br /><br />')
    html = html.gsub(',. ', ', <br /><br />')

    "<p id='note'>#{html}</p>"

  end

  def default

    filtered_siblings = @host.siblings.filter { |vessel| @host.parent.note.include?(vessel.to_s) == false }

    html = ''

    if filtered_siblings.length == 1
      html += "You see the #{filtered_siblings[0].to_html}. "
    elsif filtered_siblings.length == 2
      html += "You see the #{filtered_siblings[0].to_html} and the #{filtered_siblings[1].to_html}. "
    elsif filtered_siblings.length == 3
      html += "You see the #{filtered_siblings[0].to_html}, "
      html += "the #{filtered_siblings[1].to_html} and the #{filtered_siblings[2].to_html}. "
    elsif filtered_siblings.length > 3
      html += "You see the #{filtered_siblings[0].to_html}, "
      html += "the #{filtered_siblings[1].to_html} and "
      html += "<action-link data-action='inspect'>#{filtered_siblings.length - 2} other vessels</action-link>. "
    elsif !@host.parent.is_silent && !@host.parent.has_note
      html += "<i style='color:#999'>There is nothing here, why don't you "
      html += "<action-link data-action='create '>create</action-link> something.</i>"
    end

    "<p>#{html}</p>"

  end

  def action

    html = ''
    @host.siblings.each do |vessel|

      next unless vessel.has_program

      html += "<p id='action'>"
      html += "<vessel-link data-action='use the #{vessel}'>Use the #{vessel}.</vessel-link>"
      html += '</p>'

    end

    html

  end

  def parse_vessels_in_note(html)

    parsed_vessels = []

    $nataniev.vessels[:paradise].tunnels.each do |vessel|

      action_override = "warp to #{vessel.memory_index}"
      class_override  = 'tunnel'
      html = html.sub("#{vessel.attr} #{vessel.name}", vessel.to_html(action_override, class_override))
      parsed_vessels.append(vessel.to_s)

    end

    @host.siblings.each do |vessel|

      next if parsed_vessels.include?(vessel.to_s)

      a = vessel.has_attr ? "#{vessel.attr} " : ''

      html = html.sub("#{a}#{vessel.name}", vessel.to_html)
      parsed_vessels.append(vessel.to_s)

    end

    html

  end

  def parse_wildcards(text)

    text.scan(/(?:\(\()([\w\W]*?)(?=\)\))/).each do |str, _details|

      key = str.split(' ').first
      value = str.sub("#{key} ", '').strip
      if Kernel.const_defined?("Wildcard#{key.capitalize}")
        wc = Object.const_get("Wildcard#{key.capitalize}").new(@host, value)
        text = text.gsub("((#{str}))", wc.to_s)
      else
        text = text.gsub(str, "Error: #{key}.")
      end

    end

    text

  end

  def guide

    html = ''

    guides = @host.parent.guides

    id = 1
    guides.each do |guide|

      html += "<li><b>#{id}.</b> #{guide} </li>"
      id += 1

    end

    return "<ul id='guide'>#{html}</ul>" unless guides.empty?

    ''

  end

end
