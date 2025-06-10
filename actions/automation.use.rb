#!/bin/env ruby
require_relative '_toolkit'

# Use a vessel, activating its program
class ActionUse

  include Action

  def initialize(q = nil)

    super

    @name = 'Use'
    @verb = 'Using'
    @docs = 'Add an automation program to a vessel, making it available to the use command.'
    @examples = ['<b>use</b> the coffee machine <comment>You created a coffee.</comment>']

  end

  def act(params = '')

    target = @host.find_visible(params)

    return @host.answer(self, :error, "#{topic} do not see the #{params}.") unless target
    return @host.answer(self, :error, "The #{target} does not have a program.") unless target.has_program
    return @host.answer(self, :error, "The #{target}'s program is invalid.") unless target.program.is_valid

    @host.act(target.program.action, target.program.params.wildcards(@host))

  end

end
