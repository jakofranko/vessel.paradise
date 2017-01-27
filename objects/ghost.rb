#!/bin/env ruby
# encoding: utf-8

class Ghost

  include Vessel

  attr_accessor :unde
  attr_accessor :owner

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

  def set_unde val

    @unde = val
    save
    reload

  end

  def note

    return @note

  end

  def parent

    @parent = @parent ? $parade[@unde] : $parade[@unde]
    return @parent

  end

  def sibling name

    name = name.split(" ").last
    name = " #{name} ".gsub(" the ","").gsub(" a ","").gsub(" an ","").strip
    siblings.each do |vessel|
      if vessel.name.like(name) then return vessel end
    end
    return nil
    
  end

  def siblings

    if @siblings then return @siblings end

    @siblings = []
    id = 0
    $parade.each do |vessel|
      vessel.id = id
      if vessel.unde == @unde && id != @id
        @siblings.push(vessel)
      end
      id += 1
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

  def classes

    html = ""
    if program then html += "program" end

    return html.strip

  end

  def to_s show_attr = true

    return "<vessel class='#{@classes}' data-name='#{@name}' data-attr='#{@attr}' data-action='enter the #{@name}'>#{show_attr != false && @attr ? '<attr>'+@attr+'</attr> ' : ''}<name>#{@name}</name></vessel>"

  end

  def to_debug

    return "#{@name}:#{@attr}(#{@id})"

  end

  def encode

    return "#{@perm}-#{@unde.to_s.prepend('0',5)}-#{@owner.to_s.prepend('0',5)}-#{Timestamp.new} #{@name.to_s.append(' ',14)} #{@attr.to_s.append(' ',14)} #{@program.to_s.append(' ',41)} #{@note}"

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

  def is_stem

    if parent.unde == @unde then return true end
    return nil

  end

end