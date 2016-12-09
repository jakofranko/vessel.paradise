#!/bin/env ruby
# encoding: utf-8

class ActionTranslate

  include Action

  def initialize q = nil

    super

    @name = "Translate"
    @docs = "Translate English word into Lietal."

  end
  
  def act q = ""
    
    load_folder("#{@host.path}/objects/*")
    
    return Dictionaery.new(@host.path).translate(q,"lietal")

  end

end