#!/bin/env ruby
# encoding: utf-8

class Comment
  
  attr_accessor :id
  
  def initialize content
    
    @content = content
    
  end
  
  def timestamp
    
    return Timestamp.new(@content['TIMESTAMP'])
    
  end

  def host

    return @content["HOST"]

  end

  def from

    return @content["FROM"].to_i

  end

  def message

    return @content["MESSAGE"]

  end

  def timestamp

    return Timestamp.new(@content["TIMESTAMP"])

  end

  def vessel_name

    return $parade[from] ? $parade[from] : "ghost"

  end

  def to_s

    if message.to_s.length < 3 then return "" end
    if message.to_i > 0 && $parade[message.to_i]
      return "<li>#{vessel_name} invites you to <action data-action='warp to #{message.to_i}'>#{$parade[message.to_i]}</action>.".capitalize+"</li>"
    elsif message[-1,1] == "?"
      return "<li>#{vessel_name} asked \"<message>#{message}</message>\".".capitalize+"</li>"
    elsif message[-1,1] == "!"
      return "<li>#{vessel_name} shouts \"<message>#{message}</message>\".".capitalize+"</li>"
    elsif message[0,3] == "me "
      return "<li>#{vessel_name} <message>#{message[3,message.length-3].capitalize}</message>.".capitalize+"</li>"
    else
      return "<li>\"<message>#{message.capitalize}</message>\", says #{vessel_name}.".capitalize+"</li>"
    end

  end
  
end
