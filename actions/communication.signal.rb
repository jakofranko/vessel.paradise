#!/bin/env ruby
require_relative '_toolkit'

# Alias to say/signal where you are
class ActionSignal

  include Action

  def initialize(q = nil)

    super

    @name = 'Signal'
    @verb = 'Signaling'
    @docs = 'Broadcast your current visible parent vessel.'
    @examples = ['<b>signal</b> <comment>The black cat signals the yard.</comment>']

  end

  def act(_params = '')

    return @host.answer(self, :error, "The #{@host.parent} is hidden.") if @host.parent.is_hidden

    @host.act('say', @host.parent.memory_index.to_s)

  end

end
