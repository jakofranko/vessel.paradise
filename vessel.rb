#!/bin/env ruby
# encoding: utf-8
require 'benchmark'

class VesselParadise

  include Vessel

  def initialize

    super

    @path = File.expand_path(File.join(File.dirname(__FILE__), "/"))

    load_folder("#{@path}/objects/*")
    load_folder("#{@path}/vessels/*")

    @name = "Paradise"
    @docs = "A multiplayer interactive fiction multiverse"

    @@forum    = Memory_Array.new("forum", @path)
    @@paradise = Memory_Array.new("paradise", @path)
    @@parade   = @@paradise.to_a("teapot")
    @@player_id = nil

    $nataniev.require("corpse","http")
    install(:generic, :serve, CorpseHttp.new(self))
    install(:generic, :help)

    build_corpse

  end

  def build_corpse

    def @corpse.build

      add_meta("description","Multiplayer Interactive Fiction Multiverse")
      add_meta("keywords","paradise maeve")
      add_meta("viewport","width=device-width, initial-scale=1, maximum-scale=1")
      add_meta("apple-mobile-web-app-capable","yes")
      add_meta("apple-touch-fullscreen","yes")
      add_meta("apple-mobile-web-app-status-bar-style","black-translucent")

      add_link("reset.css", :lobby)
      add_link("font.input_mono.css", :lobby)
      add_link("font.lora.css", :lobby)
      add_link("style.fonts.css")
      add_link("style.main.css")

      add_script("core/htmx.js", :lobby)
      add_footer_script("main.js")

    end

    def @corpse.query q = nil

      Benchmark.bm do |bench|
        bench.report("Creating parade") { @@parade = @@paradise.to_a("teapot") }
      end


      parts = q.gsub("+", " ").strip.split(" ")
      @@player_id = parts.first.to_i

      @action = parts[1] ? parts[1] : "look"
      @params = parts.join(" ").sub(@@player_id.to_s, "").sub(@action, "").strip

      if @@player_id < 1 then return @body = select_random_vessel end

      @player = @@parade[@@player_id]
      @title  = "Paradise ∴ #{@player}"
      @body = %Q(
      <bg></bg>
      <view>
        #{@player.act(@action, @params)}
        <p id='indicator' class='htmx-indicator'>Paradise is forming... <span class='spinner'></span></p>
      </view>

      <form hx-post='/'
            hx-target='view'
            hx-select='view'
            hx-swap='outerHTML'
            hx-indicator="#indicator"
            class='terminal'
        >
        <input
          name='player_id'
          id='player_id'
          type='hidden'
          value='#{@@player_id}'
        />
        <input
          name='q'
          id='q'
          type='hidden'
          value='#{@@player_id}'
          hx-swap-oob='true'
        />
        <input
          name='command'
          id='command'
          placeholder='What would you like to do?'
          autofocus
          hx-swap-oob='true'
        />
      </form>
      )

    end

    def @corpse.select_random_vessel

      candidates = []
      @@parade.each do |vessel|
        if vessel.rating > 0 then next end
        candidates.push(vessel)
      end
      return "<meta http-equiv='refresh' content='0; url=/#{candidates.length > 0 ? candidates[rand(candidates.length)].memory_index : rand($parade.length)}'/>"

    end

    def @corpse.paradise ; return @@paradise; end
    def @corpse.parade; return @@parade; end
    def @corpse.parade=(new_parade); @@parade = new_parade; return @@parade; end
    def @corpse.player; return @player; end
    def @corpse.forum ; return @@forum; end
  end

  def get_player_id

    return @@player_id

  end
end
