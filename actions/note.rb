#!/bin/env ruby
# encoding: utf-8

class ActionNote

  include Action
  
  def initialize q = nil

    super

    @name = "Note"
    @docs = "TODO"

  end

  def act q = "Home"

    @host.parent.set_note(q)

    return @host.act(:look,"You added a note to #{@host.parent}.")

  end

end