#!/bin/env ruby
# encoding: utf-8

module VesselToolkit
  
  attr_accessor :id
  attr_accessor :perm
  attr_accessor :name
  attr_accessor :note
  attr_accessor :attr
  attr_accessor :unde
  attr_accessor :owner
  attr_accessor :content

  attr_accessor :program
  attr_accessor :details

  attr_accessor :is_locked
  attr_accessor :is_hidden
  attr_accessor :is_quiet 
  attr_accessor :is_frozen

  attr_accessor :is_paradox

  attr_accessor :has_note
  attr_accessor :has_program
  
  attr_accessor :classes
  attr_accessor :rank
  attr_accessor :parent

  def initialize content = nil

    super

    @name = "Void"
    @note = ""
    @owner = 0
    @perm = ""

    @program = Program.new

    @is_locked = true
    @is_hidden = true
    @is_quiet  = true
    @is_frozen = true

    @is_paradox = false

    @has_note = false
    @has_program = false

    @classes = ""
    @rank = 0
    @parent = nil

  end

  def parent

    @parent = @parent ? @parent : $parade[@unde]

    return @parent ? (@parent.id = @unde ; @parent) : VesselVoid.new

  end

  def siblings

    return parent.children

  end

  def children

    if @children then return @children end

    @children = []
    $parade.each do |vessel|
      if vessel.unde != @id then next end
      if vessel.name == @name then next end
      if is_quiet && vessel.owner != owner then next end
      @children.push(vessel)
    end
    return @children

  end

  def to_s show_attr = true, show_particle = true, show_action = true

    particle = "a "
    if @note != "" || @attr != "" then particle = "the " end
    if @attr.to_s == "" && @name[0,1] == "a" then particle = "an " end
    if @attr.to_s == "" && @name[0,1] == "e" then particle = "an " end
    if @attr.to_s == "" && @name[0,1] == "i" then particle = "an " end
    if @attr.to_s == "" && @name[0,1] == "o" then particle = "an " end
    if @attr.to_s == "" && @name[0,1] == "u" then particle = "an " end
    if @attr && @attr[0,1] == "a" then particle = "an " end
    if @attr && @attr[0,1] == "e" then particle = "an " end
    if @attr && @attr[0,1] == "i" then particle = "an " end
    if @attr && @attr[0,1] == "o" then particle = "an " end
    if @attr && @attr[0,1] == "u" then particle = "an " end

    action_attributes = show_action == true ? "data-name='#{@name}' data-attr='#{@attr}' data-action='#{has_program ? 'use the '+@name : 'enter the '+@name}'" : ""

    return "<vessel class='#{@attr} #{classes}' #{action_attributes}>#{show_particle != false ? particle : ''} #{show_attr != false && @attr ? '<attr class='+@attr+'>'+@attr+'</attr> ' : ''}<name>#{@name}</name></vessel>"

  end

  def sight

    return ""

  end

  def portal

    if is_paradox
      return "You are #{to_s} paradox. "
    elsif is_paradox
      return "You are #{to_s} in #{parent} paradox. "
    elsif is_paradox
      return "You are #{to_s} in #{parent.to_s(true,true,false)} of #{parent.parent.to_s(false,true,false)}. "
    end
    return "You are #{to_s} in #{parent.to_s(true,true,false)}. "

  end


  def to_debug

    return "#{@name}:#{@attr}(#{@id})"

  end

  def perm_code

    code = ""
    code += @is_locked == true ? "1" : "0"
    code += @is_hidden == true ? "1" : "0"
    code += @is_quiet  == true ? "1" : "0"
    code += @is_frozen == true ? "1" : "0"

    return code

  end

  def encode

    return "#{perm_code}-#{@unde.to_s.prepend('0',5)}-#{@owner.to_s.prepend('0',5)}-#{Timestamp.new} #{@name.to_s.append(' ',14)} #{@attr.to_s.append(' ',14)} #{@program.to_s.append(' ',61)} #{@note}".strip

  end

  def export

    return {
      "NAME" => @name,
      "ATTR" => @attr,
      "CODE" => "#{perm_code}-#{@unde.to_s.prepend('0',5)}-#{@owner.to_s.prepend('0',5)}-#{Timestamp.new}",
      "PROGRAM" => has_program ? program.to_s : "",
      "NOTE" => has_note ? note.to_s : ""
    }

  end

  def save

    $paradise.overwrite_line(@id+4,encode)

    return true

  end

  def reload

    @siblings = nil
    @children = nil
    @parent = nil

  end

  def destroy

    $paradise.overwrite_line(@id+4,"")

  end

end
