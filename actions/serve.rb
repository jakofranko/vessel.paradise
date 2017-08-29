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
    load_folder("#{@host.path}/vessels/*")
    load_folder("#{@host.path}/actions/*")

    $forum           = Memory_Array.new("forum",@host.path)
    $paradise        = Memory_Array.new("paradise",@host.path)
    $parade          = $paradise.to_a("ghost")

    id = 0
    $parade.each do |vessel|
      vessel.id = id
      id += 1
    end

    $player_id = q.split(" ").first.to_i

    if $player_id < 1 then return select_random_vessel end
  
    corpse           = CorpseHttp.new(@host,@query)
    corpse.query     = q
    corpse.paradise  = $paradise
    corpse.player    = $parade[q.to_i] ? $parade[q.to_i] : VesselVoid.new
    corpse.player.id = $player_id

    corpse.title   = "Paradise ∴ #{q}"

    return corpse.result

  end

  def select_random_vessel

    candidates = []
    $parade.each do |vessel|
      if vessel.rating > 0 then next end
      candidates.push(vessel)
    end

    candidate = candidates.length > 0 ? candidates[rand(candidates.length)].id : rand($parade.length)

    return "<meta http-equiv='refresh' content='0; url=/#{candidate}'/>"

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
    add_meta("apple-touch-fullscreen","yes")
    add_meta("apple-mobile-web-app-status-bar-style","black-translucent")
    
    add_link("reset.css",:lobby)
    add_link("font.input_mono.css",:lobby)
    add_link("font.lora.css",:lobby)
    add_script("core/jquery.js",:lobby)
    
    add_link("style.fonts.css")
    add_link("style.main.css")

    add_script("jquery.main.js")

  end

  def body
    
    html = ""

    @query = @query.gsub("+"," ").strip.split(" ")
    id = @query ? @query[0] : "3"
    action = @query[1] ? @query[1] : "look"
    params = @query.join(" ").sub(id,"").sub(action,"").strip

    return "<bg></bg>
    <view>
      #{@player.act(action,params)}
    </view>
    <div class='terminal'>
      <input placeholder='What would you like to do?'/>
    </div>"

  end
  
  def style
    
    return ""
    
  end

end