require_relative '../../corpse/corpse.http/corpse'

# The garb of paradise
class CorpseParadise < CorpseHttp

  TITLE = %(Paradise ∴ %<player>s).freeze
  BODY = %(
      <bg></bg>
      <ui id="ui">
        <inventory %<silence>sid="inventory">%<inventory>s</inventory>
        <view %<silence>s>
          %<action>s
        </view>
        <chat
          hx-get='/%<player_id>s'
          hx-trigger='every 4s'
          hx-select='chat'
          hx-swap='outerHTML'
          hx-sync='next form.terminal:abort'
          %<silence>sid="chat"
        >
          %<chat>s
        </chat>

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
            value='%<player_id>s'
          />
          <input
            name='q'
            id='q'
            type='hidden'
            value='%<player_id>s'
            hx-swap-oob='true'
          />
          <input
            name='command'
            id='command'
            %<silence>s
            placeholder='What would you like to do?'
            autofocus
          />
          <span id='indicator' class='htmx-indicator'>Paradise is forming... <span class='spinner'></span></span>
        </form>
      </ui>
  ).freeze

  def initialize(host)

    super(host)

    @set_mutex = Mutex.new

  end

  def build

    add_meta('description', 'Multiplayer Interactive Fiction Multiverse')
    add_meta('keywords', 'paradise maeve')
    add_meta('viewport', 'width=device-width, initial-scale=1, maximum-scale=1')
    add_meta('apple-mobile-web-app-capable', 'yes')
    add_meta('apple-touch-fullscreen', 'yes')
    add_meta('apple-mobile-web-app-status-bar-style', 'black-translucent')

    add_link('reset.css', :lobby)
    add_link('font.input_mono.css', :lobby)
    add_link('font.lora.css', :lobby)
    add_link('style.fonts.css')
    add_link('style.main.css')

    add_script('core/htmx.js', :lobby)
    add_footer_script('main.js')

  end

  def query(q = nil)

    parade = @host.paradise.to_a('teapot')

    parts = q.gsub('+', ' ').strip.split(' ')
    vessel_id = parts.first.to_i

    if vessel_id < 1
      @set_mutex.synchronize do

        return @body = select_random_vessel

      end
    end

    player_id = vessel_id
    action = parts[1] || 'look'

    # Alias base help action on Paradise vessels
    action = 'actions' if action == 'help'

    params = parts.join(' ').sub(player_id.to_s, '').sub(action, '').strip
    player = parade[player_id]
    silent = player.parent ? player.parent.is_silent : false
    silence = silent ? 'class="silent" ' : ''

    # Set the CorpseHTTP instance variables
    @set_mutex.synchronize do

      @title = "Paradise ∴ #{player}"
      @body = format(
        BODY,
        silence: silence,
        inventory: create_inventory(player.children),
        action: player.act(action, params),
        player_id: player_id,
        chat: chat(player)
      )

    end

  end

  def select_random_vessel

    candidates = []
    @host.parade.each do |vessel|

      next if vessel.rating.positive?

      candidates.push(vessel)

    end

    cl = candidates.length
    candidate = cl.positive? ? candidates[rand(cl)].memory_index : rand(@host.parade.length)
    "<meta http-equiv='refresh' content='0; url=/#{candidate}'/>"

  end

  def create_list(arr, id = nil)

    html = "<ul #{id.nil? == false ? %(id="#{id}" ) : ''}class='basic'>"
    arr.each do |item|

      html += "<li>#{item}</li>"

    end
    html += '</ul>'

    html
  end

  def create_inventory(vessels)

    arr = vessels.map { |vessel| vessel.to_html("drop #{vessel.name}") }
    html = '<h4>Carrying</h4>'
    html += create_list arr, 'carrying'
    html

  end

  def chat(player)

    html = '<h4>Forum</h4>'

    return '' if player.parent.is_silent

    messages = @host.forum.to_a('comment')

    # Can put special behavior depending on where the vessel is
    selection = if player.parent.name.like('lobby')
                  messages[messages.length - 7, 7]
                else
                  messages[messages.length - 3, 3]
                end

    arr = selection.map(&:to_s)

    html += create_list arr, 'forum'

    "<ul id='forum'>#{html}</ul>"

  end

end
