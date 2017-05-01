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

    if params.include?(" onto ") then return cast_proxy(params.split(" onto ").first,params.split(" onto ").last)
    else return cast_default(params) end

    return "#{params}"

  end

  def cast_default params

    target = @host.find_distant(params)

    if !target then return @host.answer(self,:error,"The target vessel did not answer.") end
    if !target.has_program then return @host.answer(self,:error,"The target vessel has no program.") end
      
    return @host.act(target.program.action,target.program.params.wildcards(@host))

  end

  def cast_proxy spell_name, target_name

    spell = @host.find_distant(spell_name)
    target = @host.find_visible(target_name)

    if !spell then return @host.answer(self,:error,"This spell is unknown.") end
    if !spell.program.is_valid then return @host.answer(self,:error,"#{spell} is not a valid spell.") end
    if !target then return @host.answer(self,:error,"The target vessel is not valid.") end

    return target.act(spell.program.action,spell.program.params.wildcards(target))

  end

end