#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionCast

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Cast"
    @docs = "Use a vessel program's from anywhere. By default, the spell will be cast onto the current active vessel, casting can also target a visible vessel."
    @verb = "Casting"
    @examples = [
      "cast the vanish spell\n<comment>The black cat is now hidden.</comment>",
      "cast the vanish spell onto the purple bat\n<comment>The purple bat is now hidden.</comment>"
    ]

  end

  def act target = nil, params = ""

    target = @host.find_distant(params)

    if !target then return @host.answer(self,:error,"The target vessel did not answer.") end
    if !target.has_program then return @host.answer(self,:error,"The target vessel has no program.") end
      
    return @host.act(target.program.action,target.program.params.wildcards(@host))

  end

end