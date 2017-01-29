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

    if q.to_s.strip.length < 2 then return "<p>You said nothing.</p>" end

    $forum.to_a(:comment).reverse[0,1].each do |comment|
      if comment.from == @host.id && comment.message.strip == q.strip then return "<p>You have just said that.</p>" end
    end

    $forum.append(encode(q))
    return "<p>You said \"#{q}\".</p>"
    
  end

end