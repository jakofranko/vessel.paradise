#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionAppear

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Appear"
    @docs = "Become visible."

    @target = :self

  end

  def act target = nil, params = ""

    @host.set_hidden(false)

    return @host.answer(:modal,"You reappeared.","Your warp id is now visible to other players.")
    
  end

end