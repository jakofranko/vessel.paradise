#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionSet

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Set"
    @verb = "Setting"
    @docs = "Directly write attributes for the current active vessel."
    @examples = ["set parent 16\n<comment>You are now in the yard.</comment>"]

  end

  def act target = nil, params = ""

    return "?"
    
  end

end