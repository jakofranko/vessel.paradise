#!/bin/env ruby
require_relative '_toolkit'

# Enter the parent of your current parent
class ActionLeave

  include Action

  def initialize(q = nil)

    super

    @name = 'Leave'
    @verb = 'Leaving'
    @docs = 'Exit the parent vessel.'
    @examples = ['<b>leave</b> <comment>You are a black cat in the yard.</comment>']

  end

  def act(_params = '')

    target = @host.parent.parent
    prev = @host.parent

    help = "#{topic} reached the stem of the universe. The #{prev.name} is a paradox and may not be exited."
    return @host.answer(self, :error, help) if prev.is_paradox
    return @host.answer(self, :error, "#{@host} is locked.") if @host.is_locked == true

    @host.set_unde(target.memory_index)

    @host.answer(self, :modal, "#{topic} left the #{prev}, and entered the <i>#{target}</i>.")

  end

end
