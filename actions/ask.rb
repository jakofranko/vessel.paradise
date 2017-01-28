#!/bin/env ruby
# encoding: utf-8

class ActionSay

  include Action
  
  def initialize q = nil

    super

    @name = "Say"
    @docs = "TODO"

  end

  def encode message

    return "#{Timestamp.new} #{@host.unde.to_s.prepend('0',5)} #{@host.id.to_s.prepend('0',5)} #{message}"

  end

  def act q = "Home"

    $forum.append(encode(q+"?"))
    return "<p>You asked \"#{q}\".</p>"
    
  end

end