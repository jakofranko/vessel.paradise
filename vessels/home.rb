#!/bin/env ruby
# encoding: utf-8

class VesselHome

  include Vessel
  include VesselToolkit

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

  def initialize content

    super

    @content = content

    puts "------------"
    p @content
    puts "------------"

    @name = @content["NAME"] ? @content["NAME"] : "nullspace"
    @attr = @content["ATTR"] ? @content["ATTR"] : ""
    @note = @content["NOTE"] ? @content["NOTE"] : ""
    @perm  = @content["CODE"] ? @content["CODE"].split("-")[0] : "1111"
    @unde  = @content["CODE"] ? @content["CODE"].split("-")[1].to_i : 1
    @owner = @content["CODE"] ? @content["CODE"].split("-")[2].to_i : 0
    @time  = @content["CODE"] ? @content["CODE"].split("-")[3] : Timestamp.new

    # Code

    @is_locked = @perm[0,1].to_i == 1 ? true : false
    @is_hidden = @perm[1,1].to_i == 1 ? true : false
    @is_quiet  = @perm[2,1].to_i == 1 ? true : false
    @is_frozen = @perm[3,1].to_i == 1 ? true : false
    
    @program = @content["PROGRAM"]

    @path = File.expand_path(File.join(File.dirname(__FILE__), "/"))
    @docs = "Default Paradise vessel."
    
    install(:generic,:look)
    install(:generic,:help)

    install(:basic,:become)
    install(:basic,:leave)
    install(:basic,:enter)
    install(:basic,:create)

    install(:movement,:warp)

    install(:advanced,:take)
    install(:advanced,:drop)
    install(:advanced,:lock)
    install(:advanced,:unlock)
    install(:advanced,:appear)
    install(:advanced,:vanish)

    install(:communication,:say)

    install(:narrative,:transmute)
    install(:narrative,:transform)
    install(:narrative,:describe)

    install(:programming,:program)
    install(:programming,:use)
    install(:programming,:inspect)
    install(:programming,:call)

    # install(:deconstruction,:destroy)

  end

  def act action_name, params = nil

    if Kernel.const_defined?("Action#{action_name.capitalize}") == false then return "<p>\"#{action_name.capitalize}\" is not a valid action.</p>" end

    action = Object.const_get("Action#{action_name.capitalize}").new
    action.host = self

    if action.target == :parent && parent.is_locked then return answer(:error,"#{parent} is locked.") end
    if action.target == :self && is_locked then return answer(:error,"#{to_s} is locked.") end

    return action.act(params)

  end

  def answer type, message, etc = nil

    return "<p>#{message}</p>#{etc ? '<p>'+etc+'</p>' : ''}"

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

  def classes

    html = ""
    if has_program
      if program.split(" ").first.like("warp") then html += "warp "
      elsif program.split(" ").first.like("create") then html += "machine "
      elsif program.split(" ").first.like("say") then html += "speaker "
      else html += "program " end
    end
    if unde == id then html += "stem " end

    return html.strip

  end

  def is_paradox

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

  def set_locked val

    @is_locked = val
    save
    reload

  end

  def set_hidden val

    @is_hidden = val
    save
    reload

  end

  # Testers

  def has_note

    return @note.to_s != "" ? true : false
    
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
    if is_locked then val += 1 end

    return val
    
  end

  def is_valid

    errors = []

    if name.to_s.strip == "" then errors.push("The vessel name cannot be blank.") end
    if name.length > 14 then errors.push("The vessel name cannot be more than 14 characters long.") end
    if name.length < 3 then errors.push("The vessel name cannot be less than 3 characters long.") end
    if name.has_badword then errors.push("Please do not use the word #{name.has_badword} in Paradise.") end
    if name.is_alphabetic == false then errors.push("Vessel names can only contain letters.") end

    if has_attr
      if attr.length > 14 then errors.push("The vessel attribute cannot be more than 14 characters long.") end
      if attr.length < 3 then errors.push("The vessel attribute cannot be less than 3 characters long.") end
      if attr.has_badword then errors.push("Please do not use the word #{attr.has_badword} in Paradise.") end
      if attr.is_alphabetic == false then errors.push("Vessel attributes can only contain letters.") end
      if name == attr then errors.push("Vessels cannot have the same attribute and name.") end
    end

    return errors.length > 0 ? false : true, errors

  end

  def is_unique

    $parade.each do |vessel|
      if vessel.id == @id then next end
      if vessel.name.like(@name) && vessel.attr.like(@attr) then return false end
    end
    return true

  end

  def sight

    return "unde:#{@unde}"

    html = sight_note
    html += sight_action
    html += sight_default
    html += sight_guide

    return html   
    
  end

  def sight_note

    if !has_note then return "" end

    html = Wildcard.new(note).to_s

    children.each do |vessel|
      html = html.sub(" #{vessel.name} "," #{vessel.to_s(false,false)} ")
    end

    return "<p class='note'>#{html}</p>"

  end


  def sight_action

    children.each do |vessel|
      if vessel.has_program then return "<p class='action'><vessel data-action='use the #{vessel.name}'>Use the #{vessel.name}.</vessel></p>" end
    end

    if children.length > 0
      return "<p class='action'><vessel data-action='enter the #{children.first.name}'>Enter #{children.first}.</vessel></p>"
    end

    return ""

  end

  def sight_default

    html = "" # sight_portal

    if children.length == 1
      html += "You see #{children[0]}. "
    elsif children.length == 2
      html += "You see #{children[0]} and #{children[1]}. "
    elsif children.length == 3
      html += "You see #{children[0]}, #{children[1]} and #{children[2]}. "
    elsif children.length > 3
      html += "You see #{children[0]}, #{children[1]} and #{children.length-2} other vessels. "
    else
      html += ""
    end

    return "<p>#{html}</p>"

  end

  def sight_guide

    return "<ul class='guide code'><li>You are in the Inner Haven.</li></ul>"

  end

end