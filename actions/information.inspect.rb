#!/bin/env ruby
require_relative '_toolkit'

# Look behind the curtain
class ActionInspect

  include Action

  def initialize(q = nil)

    super

    @name = 'Inspect'
    @docs = 'Get a visible vessel id.'
    @verb = 'Inspecting'
    @target = :visible

  end

  def act(params = '')

    target = @host.find_visible(params)

    target ||= @host.parent

    html = "<h3>the #{target}</h3>"
    html += "<p><b>The #{target}</b>, "
    html += "owned by the <i>#{target.creator}</i>, "
    html += "has the warp id #{target.memory_index}, "
    html += "and a vessel rating of #{target.rating}. "
    html += "The #{target.name} is currently #{target.depth} levels deep within the #{target.stem} paradox.</p>"

    html += "<p><b>Note: </b><i>#{target.note}</i></p>" if target.has_note
    html += "<code>#{target.program}</code>" if target.has_program

    # This TODO was left by Devine...don't know what he wanted to do...
    # TODO
    unless @host.siblings.empty?
      html += '<h3>Siblings</h3>'
      html += "<ul class='basic' style='margin-bottom:30px'>"
      @host.siblings.each do |vessel|

        html += "<li><action-link  data-action='enter the #{vessel}'>#{vessel}</action-link></li>"

      end
      html += '</ul>'
    end

    html += '</table>'

    html

  end

end
