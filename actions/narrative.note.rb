#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionNote

  include Action

  def initialize q = nil

    super

    @name = "Note"
    @verb = "Describing"
    @docs = "Add a description to the current parent vessel."
    @examples = ["<b>note</b> the cat is dark. <comment>The cat is dark.</comment>"]

  end

  def act params = ""

    target = @host.parent

    if params.length > 300 then return @host.answer(self, :error, "The note cannot be more than 300 characters.") end
    if params.has_badword  then return @host.answer(self, :error, "<b>#{params.has_badword}</b>, no.") end
    if target.is_locked    then return @host.answer(self, :error, "#{@host.parent} is locked.") end

    target.set_note(params)

    return @host.answer(self, :modal, "#{topic} updated the #{target}'s note.")

  end

end
