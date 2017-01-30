#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionEnter

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Enter"
    @docs = "Enter a visible vessel."

  end

  def act q = "Home"

    target = visible_named(q)

    if !target then return @host.act("look","Cannot find a target named #{q}.") end

    @host.set_unde(target.id)

    return @host.act("look","You entered #{target}. ")

  end

end