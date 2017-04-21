#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionTransform

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Transform"
    @docs = "Define the parent vessel."

    @target = :parent

  end

  def act q = "Home"

    old_attr = @host.parent.attr
    new_attr = q.split(" ").last

    if old_attr == new_attr     then return @host.answer(:error,"The #{attr} remains unchanged.") end

    @host.parent.attr = new_attr
    validity_check, validity_errors = @host.parent.is_valid

    if !validity_check          then return @host.answer(:error,"#{validity_errors.first}") end
    if !@host.parent.is_unique  then return @host.answer(:error,"Another #{@host.parent} already exists.") end
    if @host.parent.is_locked   then return @host.answer(:error,"#{@host.parent} is locked.") end

    @host.parent.set_attr(new_attr)

    return @host.answer(:modal,"You transformed the #{@host.parent.name} into #{@host.parent}.")
    
  end

end