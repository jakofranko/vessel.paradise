#!/bin/env ruby
require_relative '_toolkit'

# List all actions available
class ActionActions

  include Action

  def initialize(q = nil)

    super

    @name = 'Actions'
    @docs = 'List commands.'

  end

  def act(params = '')

    target = params.split(' ').last.to_s

    return help_spells if target.like('spells')

    help_default

  end

  def help_default

    html = '<h4>You are calling the vessel help line.</h4>'\
      "<p>Hello #{@host}, thank you for contacting the "\
      "<vessel-link data-action='warp to 1'>Vessel Help Line</vessel-link>."\
      '</p>'\
      '<p>Paradise is a multiplayer playground exploring the limits of thingspace and conceptspace. '\
      'You can learn more about the project on the '\
      "<a href='http://wiki.xxiivv.com/Paradise' target='_blank'>wiki</a>."\
      '</p>'\
      "<p>The size of Paradise is currently of #{$nataniev.vessels[:paradise].parade.length} vessels.</p>"

    html += topics

    html

  end

  def topics

    html = ''

    # Actions
    html += '<code>'
    @host.actions.each do |cat, actions|

      next if cat == :generic

      actions.each do |action|

        next if action.examples.nil?

        action.examples.each do |example|

          html += "#{example}\n"

        end

      end
      html += "\n"

    end
    html += '</code>'

    # Widlcards
    html += '<p>Wildcards are dynamic text to be used in notes and programs to create responsive narratives.</p>'
    html += '<code>'
    [WildcardTime, WildcardRandom, WildcardVessel, WildcardChildren, WildcardSiblings].each do |wildcard|

      name = wildcard.name.sub('Wildcard', '')
      wildcard.new.options.each do |option|

        html += "((<b>#{name.downcase}</b> #{option})) <comment>#{wildcard.new(@host, option)}</comment>\n"

      end

    end
    html += '</code>'

    # Spells

    html += '<p>The spellbook lists all known spells across paradise, to be used with the cast command.</p>'
    html += '<code>'
    $nataniev.vessels[:paradise].parade.each do |vessel|

      next unless vessel.has_program
      next unless vessel.is_locked
      next unless vessel.has_attr
      next unless vessel.name.like('spell')

      a = vessel.attr
      n = vessel.name
      owner = vessel.owner != 0 ? ", by the #{vessel.creator}" : ''
      html += "<action-link data-action='cast the #{a} #{n}'>#{a.capitalize}</action-link>#{owner} "
      html += "<comment>#{vessel.program}</comment>\n"

    end
    html += '</code>'

    html

  end

end
