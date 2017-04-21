#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionCreate

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Create"
    @docs = "Create a new vessel."

    @params = :name

  end

  def act q = "Home" 

    target = remove_articles(q).split(" ")

    name = target.last.to_s
    attr = target.length == 2 ? target[target.length-2].to_s : ""

    new_vessel = Ghost.new({"NAME" => name.downcase,"ATTR" => attr.downcase,"CODE" => "0000-#{@host.unde.to_s.prepend('0',5)}-#{@host.id.to_s.prepend('0',5)}-#{Timestamp.new}"})

    validity_check, validity_errors = new_vessel.is_valid

    if !validity_check then return "<p>#{validity_errors.first}</p><p>Your new vessel was swallowed by the void.</p>" end
    if !is_unique(name,attr) then return @host.act(:look,"A vessel named \"#{attr+' '+name}\" already exists.") end

    $paradise.append(new_vessel.encode)
    @host.reload

    return "<p>You created #{new_vessel.to_s(true,false)}.</p>"

  end

end