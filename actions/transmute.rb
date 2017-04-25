#!/bin/env ruby
# encoding: utf-8

require_relative "_toolkit.rb"

class ActionTransmute

  include Action
  include ActionToolkit
  
  def initialize q = nil

    super

    @name = "Transmute"
    @docs = "Rename the parent vessel."
    
    @target = :parent
    @params = :name

  end

  def act target = nil, params = ""

    old_name = @host.parent.name
    new_name = q.split(" ").last

    if old_name == new_name     then return @host.answer(:error,"The #{name} remains unchanged.") end

    @host.parent.name = new_name
    validity_check, validity_errors = @host.parent.is_valid

    if !validity_check          then return @host.answer(:error,"#{validity_errors.first}") end
    if !@host.parent.is_unique  then return @host.answer(:error,"Another #{@host.parent} already exists.") end
    if @host.parent.is_locked   then return @host.answer(:error,"#{@host.parent} is locked.") end

    @host.parent.set_name(new_name)

    return @host.answer(:modal,"You transmuted the #{old_name} into #{@host.parent}.")
    
  end

end