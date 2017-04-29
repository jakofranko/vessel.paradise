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
    
    @examples = ["enter the library\n<comment>You are in the library.</comment>"]

  end

  def act target = nil, params = ""

    if !target then return @host.answer(:error,"Cannot find a target named #{q}.") end

    @host.set_unde(target.id)

    return @host.answer(:modal,"You entered #{target}.")

  end

end