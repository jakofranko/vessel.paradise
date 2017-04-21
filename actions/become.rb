#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionBecome

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Become"
    @docs = "Become a visible vessel."
    
    @params = :visible

  end

  def act q = "Home"

    target = visible_named(q)

    if !target then return @host.answer(:error,"Cannot find a target named #{q}.") end

    return "<p>You are becoming #{target}...</p>
    <meta http-equiv='refresh' content='1; url=/#{target.id}' />"

  end

end