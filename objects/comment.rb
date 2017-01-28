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

    return $parade[from] ? $parade[from] : "a ghost"

  end

  def to_s

    if message[-1,1] == "?"
      return "#{vessel_name} asked \"#{message}\".<br/>".capitalize
    elsif message[0,2] == "me"
      return "A #{vessel_name} #{message[2,message.length-2].capitalize}.<br />".capitalize
    else
      return "\"#{message.capitalize}\", says #{vessel_name}.<br />".capitalize
    end

  end
  
end
