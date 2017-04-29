#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionSignal

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Signal"
    @docs = "Broadcast your current visible parent vessel."
    @examples = ["signal\n<comment>The black cat signals the yard.</comment>"]

  end

  def encode message

    return "#{Timestamp.new} #{@host.unde.to_s.prepend('0',5)} #{@host.id.to_s.prepend('0',5)} #{message}"

  end

  def act target = nil, params = ""

    q = q.gsub(/[^a-zZ-Z0-9\s\!\?\.\,\']/i, '')

    new_comment = Comment.new
    new_comment.inject(@host,q.to_s.strip) # 

    is_valid, error = new_comment.is_valid
    if !is_valid then return @host.answer(:error,error) end

    $forum.to_a(:comment).reverse[0,1].each do |comment|
      if comment.from == @host.id && comment.message == new_comment.message then return @host.answer(:error,"You have just said that.") end
    end

    $forum.append(new_comment.to_code)

    return @host.answer(:modal,new_comment.feedback)
    
  end

end