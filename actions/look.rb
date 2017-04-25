#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionLook

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Look"
    @docs = "Sight."

  end

  def act target = nil, params = ""

    return "<h1>#{@host.portal}</h1>#{@host.parent.sight}"

  end

  def chat

    html = ""

    messages = $forum.to_a("comment")

    count = 0
    messages[messages.length-5,5].each do |message|
      if message.timestamp.elapsed < 100000 then html += message.to_s end
      count += 1
    end

    return "<ul class='forum'>"+html+"</ul>"

  end

  

end