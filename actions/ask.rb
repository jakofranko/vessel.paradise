#!/bin/env ruby
# encoding: utf-8

class ActionAsk

  include Action
  
  def initialize q = nil

    super

    @name = "Ask"
    @docs = "Ask a question."

  end

  def encode message

    return "#{Timestamp.new} #{@host.unde.to_s.prepend('0',5)} #{@host.id.to_s.prepend('0',5)} #{message}"

  end

  def act q = "Home"

    $forum.append(encode(q+"?"))
    return "<p>You asked \"#{q}\".</p>"
    
  end

end