#!/bin/env ruby
# encoding: utf-8

class Comment
  
  attr_accessor :id
  
  def initialize content = {}
    
    @content = content
    
  end
  
  def timestamp
    
    return Timestamp.new(@content['TIMESTAMP'])
    
  end

  def inject host,message

    @content["TIMESTAMP"] = Timestamp.new
    @content["HOST"] = host.id
    @content["FROM"] = host.unde
    @content["MESSAGE"] = message

  end

  def host

    return @content["HOST"].to_i

  end

  def from

    return @content["FROM"].to_i

  end

  def message

    return @content["MESSAGE"].to_s

  end

  def timestamp

    return Timestamp.new(@content["TIMESTAMP"])

  end

  def vessel_name

    if !$parade[from] then return "ghost" end

    vessel = $parade[from]
    return "#{vessel.to_s(true,true,false,false)} #{vessel.link} #{vessel.parent.to_s(false,true,false,false)}"

  end

  def to_code

    return "#{Timestamp.new} #{from.to_s.prepend('0',5)} #{host.to_s.prepend('0',5)} #{message}"

  end

  def feedback

    if is_question then return "You asked \"#{message}\"?" end
    if is_shout then return "You shouted \"#{message}\"" end
    if is_emote then return "You #{message[3,message.length-3]}." end
    if is_warp then return "You indicated <action data-action='warp to #{message}'>≡#{message.to_i}</action>." end

    return "You said \"#{message}\"."

  end

  def to_s

    if is_question then return "<li>#{vessel_name.capitalize} asked \"<message>#{message.capitalize}?</message>\".</li>" end
    if is_shout then return "<li>#{vessel_name.capitalize} shouts \"<message>#{message.capitalize}</message>\".</li>" end
    if is_emote then return "<li>#{vessel_name.capitalize} <message>#{message[3,message.length-3]}</message>.</li>" end
    if is_warp then return "<li>#{vessel_name.capitalize} invites you to <action data-action='warp to #{message.to_i}'>#{$parade[message.to_i]}</action>.</li>" end

    return "<li>— \"<message>#{message.capitalize}</message>\", says #{vessel_name}.</li>"

  end

  def is_valid

    if message == "" then return false, "You said nothing." end
    if message.upcase == message && message.to_i < 1 then return false, "Please, don't shout." end

    return true

  end

  def is_question

    question_words = ["are","is","does","who","what","where","when","how","why","which"]
    first_word = message.split(" ").first.to_s

    question_words.each do |word|
      if first_word.like(word) then return true end
    end

    return false

  end

  def is_shout

    return message[-1,1] == "!" ? true : false

  end

  def is_emote

    return message[0,3] == "me " ? true : false

  end

  def is_warp

    return message.to_i > 0 ? true : false

  end
  
end
