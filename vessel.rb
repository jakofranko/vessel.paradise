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
    @tunnels = nil

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


      @@parade = @@paradise.to_a("teapot")

      parts = q.gsub("+", " ").strip.split(" ")
      vessel_id = parts.first.to_i
      @@player_id = vessel_id < 1 ? select_random_vessel : vessel_id

      @action = parts[1] ? parts[1] : "look"

      # It's not pretty, but we need to alias the base help action on Paradise vessels
      if @action == 'help' then @action = 'actions' end

      @params = parts.join(" ").sub(@@player_id.to_s, "").sub(@action, "").strip
      @player = @@parade[@@player_id]
      @title  = "Paradise ∴ #{@player}"
      silent = @player.parent.is_silent
      silence = silent ? 'class="silent" ' : ''

      @body = %Q(
      <bg></bg>
      <ui id="ui">
        <inventory #{silence}id="inventory">#{self.create_inventory(@player.children)}</inventory>
        <view #{silence}>
          #{@player.act(@action, @params)}
        </view>
        <chat #{silence}id="chat">#{self.chat}</chat>

        <form hx-post='/'
              hx-target='view'
              hx-select='view'
              hx-swap='outerHTML'
              hx-swap-oob='true'
              hx-select-oob='#command, #inventory, #chat'
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
            #{silence}
            placeholder='What would you like to do?'
            autofocus
          />
          <span id='indicator' class='htmx-indicator'>Paradise is forming... <span class='spinner'></span></span>
        </form>
      </ui>
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

    def @corpse.paradise; return @@paradise; end
    def @corpse.parade; return @@parade; end
    def @corpse.parade=(new_parade); @@parade = new_parade; return @@parade; end
    def @corpse.player; return @player; end
    def @corpse.forum; return @@forum; end
    def @corpse.create_list arr, id = nil

      html = "<ul #{id.nil? == false ? 'id="' + id + '" ' : ''}class='basic'>"
      arr.each do |item|
        html += "<li>#{item.to_s}</li>"
      end
      html += "</ul>"

      return html
    end
    def @corpse.create_inventory vessels

      arr = vessels.map {|vessel| vessel.to_html("drop #{vessel.name}")}
      html = "<h4>Carrying</h4>"
      html += create_list arr, 'carrying'
      return html

    end
    def @corpse.chat

        html = "<h4>Forum</h4>"

        if self.player.parent.is_silent then return "" end

        messages = @@forum.to_a("comment")

        selection = self.player.parent.name.like("lobby") ? messages[messages.length - 7, 7] : messages[messages.length - 3, 3]

        arr = selection.map{|message| message.to_s}

        html += create_list arr, 'forum'

        return "<ul id='forum'>#{html}</ul>"

    end
  end

  def tunnels

    if @tunnels then return @tunnels end

    @tunnels = []
    @@parade.each do |vessel|
      if !vessel.is_tunnel then next end
      @tunnels.push(vessel)
    end

    return @tunnels

  end

  def get_player_id

    return @@player_id

  end
end
