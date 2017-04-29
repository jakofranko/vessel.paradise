#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionCreate

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Create"
    @docs = "Create a new vessel at your current location. Vessel names and attributes must include less than 14 characters and be unique. "

    @examples = ["create a black cat\n<comment>You see a black cat.</comment>"]

  end

  def act target = nil, params = ""

    target = remove_articles(params).split(" ")

    name = target.last.to_s
    attr = target.length == 2 ? target[target.length-2].to_s : ""

    new_vessel = Ghost.new({"NAME" => name.downcase,"ATTR" => attr.downcase,"CODE" => "0000-#{@host.unde.to_s.prepend('0',5)}-#{@host.id.to_s.prepend('0',5)}-#{Timestamp.new}"})

    validity_check, validity_errors = new_vessel.is_valid

    if !validity_check then return @host.answer(:error,"#{validity_errors.first}") end
    if !is_unique(name,attr) then return @host.answer(:error,"A vessel named \"#{attr+' '+name}\" already exists.") end

    $paradise.append(new_vessel.encode)
    @host.reload

    return @host.answer(:modal,"You created #{new_vessel.to_s(true,true)}.")

  end

end