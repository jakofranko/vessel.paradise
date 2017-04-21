#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionDescribe

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Describe"
    @docs = "Describe the parent vessel."
    
    @target = :parent

  end

  def act q = "Home"

    if q.length > 300 then return "<p>The note cannot be more than 300 characters.</p>" end
    if q.has_badword then return "<p><b>#{q.has_badword}</b>, no.</p>" end
    if @host.parent.owner.to_i != @host.id.to_i && !is_improvement(@host.parent.note,q) then return "<p>This was not an improvement on the current note.</p>" end
    if @host.parent.is_locked == true then return "<p>#{@host.parent} is locked.</p>" end
    
    @host.parent.set_note(q)

    return @host.act(:look,"You updated #{@host.parent}'s note.")

  end

end