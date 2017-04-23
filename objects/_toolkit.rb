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
  attr_accessor :program
  attr_accessor :content

  attr_accessor :is_locked
  attr_accessor :is_hidden
  attr_accessor :is_quiet 
  attr_accessor :is_frozen

  attr_accessor :is_paradox

  attr_accessor :has_note
  attr_accessor :has_program
  
  attr_accessor :classes

  def initialize content = nil

    super

    @name = "The Void"
    @note = ""
    @owner = 0
    @perm = ""

    @is_locked = true
    @is_hidden = true
    @is_quiet  = true
    @is_frozen = true

    @is_paradox = false

    @has_note = false
    @has_program = false

    @classes = ""

  end

  def parent

    return $parade[0]

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

end
