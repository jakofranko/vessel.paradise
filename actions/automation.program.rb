#!/bin/env ruby
require_relative '_toolkit'

# Add automation to a vessel
class ActionProgram

  include Action

  def initialize(q = nil)

    super

    @name = 'Program'
    @verb = 'Programming'
    @docs = 'Add an automation program to a vessel, '\
            'making it available to the use command. '\
            'A program cannot exceed 60 characters in length.'
    @examples = ['<b>program</b> create a coffee']

  end

  def act(params = '')

    target = @host.parent
    program = Program.new(@host, params)

    return @host.answer(self, :error, "The #{target} is locked.") if target.is_locked == true

    unless program.is_valid
      al = "<action-link data-action='actions'>programming guide</action-link>"
      help = "You can learn about valid programs in the #{al}."
      return @host.answer(self, :error, 'The program is not valid.', help)
    end

    target.set_program(params)

    @host.answer(self, :modal, "#{topic} updated the #{target}'s program.")

  end

end
