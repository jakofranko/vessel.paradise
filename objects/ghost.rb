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
    @note = @content["NOTE"]
    @type,@unde,@owner,@time = @content["CODE"].split("-")
    @unde = @unde.to_i

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

    @parent = @parent ? $paradise[@unde] : $paradise[@unde]
    return @parent

  end

  def siblings

    if @siblings then return @siblings end

    @siblings = []
    $paradise.each do |vessel|
      if vessel.unde != @unde then next end
      if vessel.name == @name then next end
      @siblings.push(vessel)
    end
    return @siblings

  end

  def children

    if @children then return @children end

    @children = []
    $paradise.each do |vessel|
      if vessel.unde != @id then next end
      if vessel.name == @name then next end
      @children.push(vessel)
    end
    return @children

  end

  def to_s

    return "<vessel><attr>#{@attr}</attr> <name>#{@name}</name></vessel>"

  end

  def encode



  end

end