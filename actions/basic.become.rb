#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionBecome

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Become"
    @verb = "Becoming"
    @docs = "Become a visible vessel, the target vessel must be present and visible in the current parent vessel. Adding a bookmark with your browser will preserve your vessel id for your return."

    @examples = ["become the black cat\n<comment>You are a black cat.</comment>"]

  end

  def act target = nil, params = ""

    target = visible_named(q)

    if !target then return @host.answer(self,:error,"Cannot find a target named #{q}.") end

    return "<p>You are becoming #{target}...</p>
    <meta http-equiv='refresh' content='1; url=/#{target.id}' />"

  end

end