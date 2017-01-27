#!/bin/env ruby
# encoding: utf-8

class Ghost

  include Vessel

  attr_accessor :unde

  def initialize content

    super

    @content = content

    @name = @content["NAME"]
    @attr = @content["ATTR"]
    @note = @content["NOTE"] ? @content["NOTE"] : ""
    @perm,@unde,@owner,@time = @content["CODE"].split("-")
    @unde = @unde.to_i
    @program = @content["PROGRAM"]

    @path = File.expand_path(File.join(File.dirname(__FILE__), "/"))
    @docs = "Default Paradise vessel."
    
    install(:paradise,:look)
    install(:paradise,:leave)
    install(:generic,:help)

  end

  def note

    return @note

  end

  def parent

    @parent = @parent ? $parade[@unde] : $parade[@unde]
    return @parent

  end

  def siblings

    if @siblings then return @siblings end

    @siblings = []
    $parade.each do |vessel|
      if vessel.unde != @unde then next end
      if vessel.name == @name then next end
      @siblings.push(vessel)
    end
    return @siblings

  end

  def children

    if @children then return @children end

    @children = []
    $parade.each do |vessel|
      if vessel.unde != @id then next end
      if vessel.name == @name then next end
      @children.push(vessel)
    end
    return @children

  end

  def to_s

    return "<vessel data-name='#{@name}' data-attr='#{@attr}' data-action='enter the #{@name}'><attr>#{@attr}</attr> <name>#{@name}</name></vessel>"

  end

  def encode

    return "#{@perm}-#{@unde.to_s.prepend('0',5)}-#{@owner.to_s.prepend('0',5)}-#{Timestamp.new} #{@name.to_s.append(' ',14)} #{@attr.to_s.append(' ',14)} #{@program.to_s.append(' ',41)} #{@note}"

  end

  def save

    $paradise.overwrite_line(@id+4,encode)

    return true

  end

end