#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionNote

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Note"
    @docs = "Describe the parent vessel."

  end

  def act q = "Home"

    if q.length > 300 then return "<p>The note cannot be more than 300 characters.</p>" end
    if !is_valid(q) then return "<p>Nope!</p>" end
    if @host.parent.owner.to_i != @host.id.to_i && !is_improvement(@host.parent.note,q) then return "<p>This was not an improvement on the current note.</p>" end
    
    @host.parent.set_note(q)

    return @host.act(:look,"You updated #{@host.parent}'s note.")

  end

end