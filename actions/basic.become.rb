#!/bin/env ruby
require_relative '_toolkit'

# Become another vessel
class ActionBecome

  include Action

  def initialize(q = nil)

    super

    @name = 'Become'
    @verb = 'Becoming'
    @docs = 'Become a visible vessel, the target vessel must be present '\
            'and visible in the current parent vessel. '\
            'Adding a bookmark with your browser will preserve your vessel id for your return.'
    @examples = ['<b>become</b> the black cat <comment>You are a black cat.</comment>']

  end

  def act(params = '')

    target = @host.find_visible(params)

    return @host.answer(self, :error, "#{topic} cannot find the target vessel.") unless target

    "<p>You are becoming #{target}...</p>
    <meta http-equiv='refresh' content='1; url=/#{target.memory_index}' />"

  end

end
