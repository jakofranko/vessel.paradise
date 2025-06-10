#!/bin/env ruby
require_relative '_toolkit'

# Make a child vessel a sibling vessel
class ActionDrop

  include Action

  def initialize(q = nil)

    super

    @name = 'Drop'
    @verb = 'Droping'
    @docs = 'Move a child vessel into the parent vessel.'
    @examples = ['<b>drop</b> the scissor <comment>You see the scissor.</comment>']

  end

  def act(params = '')

    target = @host.find_child(params)

    return @host.answer(self, :error, 'Cannot find the target vessel.') unless target
    return @host.answer(self, :error, "#{target} is locked.") if target.is_locked

    target.set_unde(@host.unde)

    # Target is now a sibling of the host and not a child
    @host.reset_siblings
    @host.reset_children

    @host.answer(self, :modal, "#{topic} dropped the #{target}.")

  end

end
