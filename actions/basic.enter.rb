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

    target = @host.find_visible(params)
    
    if !target then return @host.answer(:error,"Cannot find a target named #{params}.") end

    @host.set_unde(target.id)

    return @host.answer(:modal,"You entered the #{target.to_s(true,false)}.")

  end

end