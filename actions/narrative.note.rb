#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionNote

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Note"
    @docs = "Add a description to the current parent vessel."
    @examples = ["note the cat is dark.\n<comment>The cat is dark.</comment>"]

  end

  def act target = nil, params = ""

    if params.length > 300 then return @host.answer(:error,"The note cannot be more than 300 characters.") end
    if params.has_badword then return @host.answer(:error,"<b>#{q.has_badword}</b>, no.") end
    if @host.parent.owner.to_i != @host.id.to_i && !is_improvement(@host.parent.note,params) then return @host.answer(:error,"This was not an improvement on the current note.") end
    if @host.parent.is_locked == true then return @host.answer(:error,"#{@host.parent} is locked.") end
    
    @host.parent.set_note(params)

    return @host.answer(:modal,"You updated #{@host.parent}'s note.")

  end

end