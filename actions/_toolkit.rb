#!/bin/env ruby

# Common tools to be used in actions
module Action

  attr_accessor :verb, :params, :target, :examples

  def topic

    # TODO: this is always going to be false because this global
    # doesn't exist any more. Figure out a way to add this back?
    $player_id == @host.memory_index ? 'You' : "The #{@host.name}"

  end

end
