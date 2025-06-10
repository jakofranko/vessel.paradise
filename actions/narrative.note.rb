#!/bin/env ruby
require_relative '_toolkit'

# Add a description to a vessel
class ActionNote

  include Action

  def initialize(q = nil)

    super

    @name = 'Note'
    @verb = 'Describing'
    @docs = 'Add a description to the current parent vessel.'
    @examples = ['<b>note</b> the cat is dark. <comment>The cat is dark.</comment>']

  end

  def act(params = '')

    target = @host.parent

    return @host.answer(self, :error, 'The note cannot be more than 300 characters.') if params.length > 300
    return @host.answer(self, :error, "<b>#{params.has_badword}</b>, no.") if params.has_badword
    return @host.answer(self, :error, "#{@host.parent} is locked.") if target.is_locked

    target.set_note(params)

    @host.answer(self, :modal, "#{topic} updated the #{target}'s note.")

  end

end
