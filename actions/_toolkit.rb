#!/bin/env ruby

# Common tools to be used in actions
module Action

  attr_accessor :verb, :params, :target, :examples

  def topic

    $player_id == @host.memory_index ? 'You' : "The #{@host.name}"

  end

end
