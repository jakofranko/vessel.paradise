#!/bin/env ruby
require_relative '_toolkit'

# Make a sibling vessel a child vessel
class ActionTake

  include Action

  def initialize(q = nil)

    super

    @name = 'Take'
    @verb = 'Taking'
    @docs = 'Move a visible vessel into a child vessel.'
    @examples = ['<b>take</b> the scissor <comment>You carry the scissor.</comment>']

  end

  def act(params = '')

    target = @host.find_visible(params)

    return @host.answer(self, :error, 'Cannot find the target vessel.') unless target
    return @host.answer(self, :error, "#{target} is locked.") if target.is_locked

    target.set_unde(@host.memory_index)

    # The target is no longer a sibling of the host but a child
    @host.reset_siblings
    @host.reset_children

    @host.answer(self, :modal, "#{topic} took the #{target}.")

  end

end
