#!/bin/env ruby
# encoding: utf-8

$nataniev.require("corpse","http")

class ActionServe

  include Action

  def initialize q = nil

    super

    @name = "Serve"
    @docs = "Deliver the Paradise API."

  end

  def act q = nil
    
    load_folder("#{@host.path}/objects/*")

    $paradise        = Memory_Array.new("paradise",@host.path).to_a("ghost")
    corpse           = CorpseHttp.new(@host,@query)
    corpse.query     = q
    corpse.paradise  = $paradise
    corpse.player    = corpse.paradise[q.to_i] ? corpse.paradise[q.to_i] : Ghost.new
    corpse.player.id = q.to_i

    corpse.title   = "Paradise ∴ #{q}"

    return corpse.result

  end

end

class CorpseHttp

  attr_accessor :path
  attr_accessor :query
  attr_accessor :paradise
  attr_accessor :player
  
  def build

    add_meta("description","Works of Devine Lu Linvega")
    add_meta("keywords","aliceffekt, traumae, devine lu linvega")
    add_meta("viewport","width=device-width, initial-scale=1, maximum-scale=1")
    add_meta("apple-mobile-web-app-capable","yes")
    
    add_link("style.reset.css")
    add_link("style.fonts.css")
    add_link("style.main.css")

    add_script("jquery.core.js")
    add_script("jquery.main.js")

  end

  def body
    
    html = ""

    html += "query:#{@query}<br/>"
    html += "player:#{@player}<br/>"
    html += "look:#{@player.act('look')}<br/>"

    return html

  end
  
  def style
    
    return ""
    
  end

end