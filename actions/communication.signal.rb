#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionSignal

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Signal"
    @verb = "Signaling"
    @docs = "Broadcast your current visible parent vessel."
    @examples = ["signal\n<comment>The black cat signals the yard.</comment>"]

  end

  def encode message

    return "#{Timestamp.new} #{@host.unde.to_s.prepend('0',5)} #{@host.id.to_s.prepend('0',5)} #{message}"

  end

  def act target = nil, params = ""

    if @host.parent.is_silent then return @host.answer(self,:error,"The #{@host.parent.name} is a silent vessel, #{topic.downcase} may not talk in here.") end
      
    q = q.gsub(/[^a-zZ-Z0-9\s\!\?\.\,\']/i, '')

    new_comment = Comment.new
    new_comment.inject(@host,q.to_s.strip) # 

    is_valid, error = new_comment.is_valid
    if !is_valid then return @host.answer(self,:error,error) end

    $forum.to_a(:comment).reverse[0,1].each do |comment|
      if comment.from == @host.id && comment.message == new_comment.message then return @host.answer(self,:error,"#{topic} just said that.") end
    end

    $forum.append(new_comment.to_code)

    return @host.answer(self,:modal,new_comment.feedback)
    
  end

end