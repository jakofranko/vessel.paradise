#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionTransform

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Transform"
    @verb = "Transforming"
    @docs = "Change your current vessel name and attribute."
    @examples = ["transform into a red bat\n<comment>You are a red bat.</comment>"]

  end

  def act target = nil, params = ""

    old_attr = @host.parent.attr
    new_attr = q.split(" ").last

    if old_attr == new_attr     then return @host.answer(self,:error,"The #{attr} remains unchanged.") end

    @host.parent.attr = new_attr
    validity_check, validity_errors = @host.parent.is_valid

    if !validity_check          then return @host.answer(self,:error,"#{validity_errors.first}") end
    if !@host.parent.is_unique  then return @host.answer(self,:error,"Another #{@host.parent} already exists.") end
    if @host.parent.is_locked   then return @host.answer(self,:error,"#{@host.parent} is locked.") end

    @host.parent.set_attr(new_attr)

    return @host.answer(self,:modal,"#{topic} transformed the #{@host.parent.name} into #{@host.parent}.")
    
  end

end