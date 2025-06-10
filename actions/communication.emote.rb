#!/bin/env ruby
require_relative '_toolkit'

# Alias say action for emoting
class ActionEmote

  include Action

  def initialize(q = nil)

    super

    @name = 'Emote'
    @verb = 'Emoting'
    @docs = 'Add an emote message into the global dialog.'
    @examples = ['<b>emote</b> waves <comment>A black cat waves.</comment>']

  end

  def act(params = '')

    @host.act('say', "me #{params}")

  end

end
