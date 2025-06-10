#!/bin/env ruby
require_relative '_toolkit'

# Communicate on the Forum
class ActionSay

  include Action

  def initialize(q = nil)

    super

    @name = 'Say'
    @verb = 'Saying'
    @docs = 'Add a message into the global dialog.'
    @examples = ['<b>say</b> hello <comment>A black cat said hello.</comment>']

  end

  def act(params = '')

    new_comment = Comment.new
    new_comment.inject(@host, params)

    is_valid, error = new_comment.is_valid

    p = @host.parent
    silent = "The #{p} is a silent vessel, #{topic.downcase} may not talk in here."

    return @host.answer(self, :error, error) unless is_valid
    return @host.answer(self, :error, silent) if p.is_silent
    return @host.answer(self, :error, "#{topic} just said that.") if new_comment.is_repeated

    $nataniev.vessels[:paradise].forum.append(new_comment.to_code)

    @host.answer(self, :modal, new_comment.feedback)

  end

end
