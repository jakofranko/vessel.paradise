#!/bin/env ruby
# encoding: utf-8

class ActionPrint

  include Action

  def initialize q = nil

    super

    @name = "Print"
    @docs = "List Dictionaery content as JSON."

  end
  
  def act q = ""

    load_folder("#{@host.path}/objects/*")

    d = Memory_Hash.new("dictionaery",@host.path).to_h
    d.each do |aeth,content|
      d[aeth]['ADL'] = Aeth.new(aeth).adultspeak
    end

    require 'json'

    return d.to_json

  end

end