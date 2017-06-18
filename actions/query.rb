#!/bin/env ruby
# encoding: utf-8

$nataniev.require("corpse","http")

class ActionQuery

  include Action

  def initialize q = nil

    super

    @name = "Query"
    @docs = "Deliver the Paradise API."

  end

  def act q = nil
    
    load_folder("#{@host.path}/objects/*")
    load_folder("#{@host.path}/vessels/*")
    load_folder("#{@host.path}/actions/*")

    $forum = Memory_Array.new("forum",@host.path)

    messages = $forum.to_a

    html = ""
    messages.each do |message|
      html += message.to_s
    end

    return html

    return $forum.to_s

    return "hello"

  end

end