#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionVanish

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Vanish"
    @docs = "Become invisible."

    @target = :self

  end

  def act target = nil, params = ""

    @host.set_hidden(true)

    return @host.answer(:modal,"You vanished.","Your warp ID is now hidden from the world.")
    
  end

end