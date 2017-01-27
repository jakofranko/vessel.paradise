#!/bin/env ruby
# encoding: utf-8

class ActionLeave

  include Action
  
  def initialize q = nil

    super

    @name = "Leave"
    @docs = "TODO"

  end

  def act q = "Home"

    @host.unde = @host.parent.unde
    confirmation = @host.save

    return "<p>You left the #{@host.parent}, and entered the #{@host.parent.parent}.</p>
    <p>Have a <action data-action='look'>look around</action>.</p>#{confirmation}"

  end

end