#!/bin/env ruby
# encoding: utf-8

class Ghost

  include Vessel

  attr_accessor :id
  attr_accessor :name
  attr_accessor :note
  attr_accessor :attr
  attr_accessor :unde
  attr_accessor :owner
  attr_accessor :program

  def initialize content

    super

    @content = content

    @name = @content["NAME"] ? @content["NAME"] : "nullspace"
    @attr = @content["ATTR"] ? @content["ATTR"] : ""
    @note = @content["NOTE"] ? @content["NOTE"] : ""
    @perm  = @content["CODE"] ? @content["CODE"].split("-")[0] : "1111"
    @unde  = @content["CODE"] ? @content["CODE"].split("-")[1].to_i : 1
    @owner = @content["CODE"] ? @content["CODE"].split("-")[2].to_i : 0
    @time  = @content["CODE"] ? @content["CODE"].split("-")[3] : Timestamp.new
    
    @program = @content["PROGRAM"]

    @path = File.expand_path(File.join(File.dirname(__FILE__), "/"))
    @docs = "Default Paradise vessel."
    
    install(:generic,:look)
    install(:generic,:help)
    install(:generic,:inspect)

    install(:basic,:become)
    install(:basic,:leave)
    install(:basic,:enter)
    install(:basic,:create)

    install(:advanced,:warp)
    install(:advanced,:take)
    install(:advanced,:drop)

    install(:communication,:say)
    install(:communication,:ask)

    install(:advanced,:transmute)
    install(:advanced,:make)
    install(:control,:note)
    install(:control,:program)
    install(:control,:use)

  end

  def to_s show_attr = true

    particle = "a "
    if @note != "" || @attr != "" then particle = "the " end
    if @attr && @attr[0,1] == "a" then particle = "an " end
    if @attr.to_s == "" && @name[0,1] == "a" then particle = "an " end

    return "<vessel class='#{classes}' data-name='#{@name}' data-attr='#{@attr}' data-action='#{has_program ? 'use the '+@name : 'enter the '+@name}'>#{particle} #{show_attr != false && @attr ? '<attr class='+@attr+'>'+@attr+'</attr> ' : ''}<name>#{@name}</name></vessel>"

  end

  def parent

    @parent = @parent ? @parent : $parade[@unde]

    return @parent ? (@parent.id = @unde ; @parent) : Void.new

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
    $parade.each do |vessel|
      if vessel.unde == @unde && vessel.id != @id && vessel.id != @unde
        @siblings.push(vessel)
      end
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

  def child name

    name = name.split(" ").last
    name = " #{name} ".gsub(" the ","").gsub(" a ","").gsub(" an ","").strip

    children.each do |vessel|
      if vessel.name.like(name) then return vessel end
    end

    return nil

  end

  def classes

    html = ""
    if has_program
      if program.split(" ").first.like("warp") then html += "warp"
      elsif program.split(" ").first.like("create") then html += "machine"
      else html += "program" end
    end
    if unde == id then html += "stem " end

    return html.strip

  end

  def to_debug

    return "#{@name}:#{@attr}(#{@id})"

  end

  def encode

    return "#{@perm}-#{@unde.to_s.prepend('0',5)}-#{@owner.to_s.prepend('0',5)}-#{Timestamp.new} #{@name.to_s.append(' ',14)} #{@attr.to_s.append(' ',14)} #{@program.to_s.append(' ',41)} #{@note}".strip

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

    if id == @unde then return true end
    return nil

  end

  # Setters

  def set_note val

    @note = val
    save
    reload

  end

  def set_unde val

    @unde = val.to_i
    save
    reload

  end

  def set_program val

    @program = val
    save
    reload

  end

  def set_name val

    @name = val
    save
    reload

  end

  def set_attr val

    @attr = val
    save
    reload

  end

  # Testers

  def has_note

    return @note.to_s != "" && @note.length > 10 ? true : false
    
  end

  def has_attr

    return @attr.to_s != "" ? true : false
    
  end

  def has_program

    return @program.to_s != "" ? true : false
    
  end

  #

  def rank

    val = 0

    if has_note then val += 1 end
    if has_attr then val += 1 end
    if has_program then val += 1 end

    return val
  end

end