#!/bin/env ruby
# encoding: utf-8

class ActionNote

  include Action
  
  def initialize q = nil

    super

    @name = "Note"
    @docs = "Describe the parent vessel."

  end

  def act q = "Home"

    if is_valid(q) == false then return "<p>Nope!</p>" end
    if q.length > 300 then return "<p>The note cannot be more than 300 characters.</p>" end
      
    @host.parent.set_note(q)

    if q.length < 5
      @host.parent.set_note("")
      return "<p>You have removed #{@host.parent} note.</p>" 
    end

    return @host.act(:look,"You added a note to #{@host.parent}.")

  end

  def is_valid note

    $BADWORDS.each do |word|
      if note.include?(word) then return false end
    end
    return true

  end

end