#!/bin/env ruby
require_relative '_toolkit'

# Enter a visible vessel
class ActionEnter

  include Action

  def initialize(q = nil)

    super

    @name = 'Enter'
    @docs = 'Enter a visible vessel.'
    @verb = 'Entering'
    @examples = ['<b>enter</b> the library <comment>You are in the library.</comment>']

  end

  def act(params = '')

    target = @host.find_visible(params)
    prev = @host.parent

    return @host.answer(self, :error, "#{topic} could not find the target vessel.") unless target
    return @host.answer(self, :error, "You already are in #{target}.") if target.memory_index == prev.memory_index
    return @host.answer(self, :error, "#{@host} is locked.") if @host.is_locked == true

    @host.set_unde(target.memory_index)

    al = "<action-link data-action='leave'>leave</action-link>"
    help = "Press <b>enter</b> to continue or type #{al} to return to the #{prev}."
    @host.answer(self, :modal, "#{topic} entered the #{target}. ", help)

  end

end
