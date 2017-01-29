#!/bin/env ruby
# encoding: utf-8

class ActionSay

  include Action
  
  def initialize q = nil

    super

    @name = "Say"
    @docs = "Say something."

  end

  def encode message

    return "#{Timestamp.new} #{@host.unde.to_s.prepend('0',5)} #{@host.id.to_s.prepend('0',5)} #{message}"

  end

  def act q = "Home"

    if q.to_s.length < 2 then return "<p>You said nothing.</p>" end
      
    $forum.append(encode(q))
    return "<p>You said \"#{q}\".</p>"
    
  end

end