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

    return "<message>"+@content["MESSAGE"]+"</message>"

  end

  def timestamp

    return Timestamp.new(@content["TIMESTAMP"])

  end

  def vessel_name

    return $parade[from] ? $parade[from] : "ghost"

  end

  def to_s

    if message[-1,1] == "?"
      return "<li>#{vessel_name} asked \"#{message}\".<br/>".capitalize+"</li>"
    elsif message[-1,1] == "!"
      return "<li>#{vessel_name} shouts \"#{message}\".<br/>".capitalize+"</li>"
    elsif message[0,3] == "me "
      return "<li>#{vessel_name} #{message[3,message.length-3].capitalize}.<br />".capitalize+"</li>"
    else
      return "<li>\"#{message.capitalize}\", says a #{vessel_name}.<br />".capitalize+"</li>"
    end

  end
  
end
