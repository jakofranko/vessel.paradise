#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionSay

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Say"
    @docs = "Say something."

    @params = :text

  end

  def encode message

    return "#{Timestamp.new} #{@host.unde.to_s.prepend('0',5)} #{@host.id.to_s.prepend('0',5)} #{message}"

  end

  def act q = "Home"

    if q.to_s.strip.length < 2 then return @host.answer(:error,"You said nothing.") end

    $forum.to_a(:comment).reverse[0,1].each do |comment|
      if comment.from == @host.id && comment.message.strip == q.strip then return @host.answer(:error,"You have just said that.") end
    end

    $forum.append(encode(q))
    
    return @host.answer(:modal,"You said \"#{q}\".")
    
  end

end