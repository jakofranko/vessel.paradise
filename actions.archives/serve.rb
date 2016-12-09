#!/bin/env ruby
# encoding: utf-8

class ActionServe

  include Action

  def initialize q = nil

    super

    @name = "Serve"
    @docs = "Deliver html documentation."

  end
  
  def act q = ""

    load_folder("#{@host.path}/objects/*")

    docs = Documentation.new(@host.path)
    dict = Dictionaery.new(@host.path)

    docs.dictionaery = dict

    return docs.to_s

  end

end