#!/bin/env ruby
# encoding: utf-8

class Ghost

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

    return "<h1>#{portal}</h1><p>#{message}</p>#{etc ? '<p>'+etc+'</p>' : ''}"

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

  def to_debug

    return "#{@name}:#{@attr}(#{@id})"

  end

  def encode

    code = ""
    code += @is_locked == true ? "1" : "0"
    code += @is_hidden == true ? "1" : "0"
    code += @is_quiet  == true ? "1" : "0"
    code += @is_frozen == true ? "1" : "0"

    return "#{code}-#{@unde.to_s.prepend('0',5)}-#{@owner.to_s.prepend('0',5)}-#{Timestamp.new} #{@name.to_s.append(' ',14)} #{@attr.to_s.append(' ',14)} #{@program.to_s.append(' ',61)} #{@note}".strip

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
    if is_hidden then val += 1 end
    if is_quiet then val += 1 end

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

    html = sight_note
    html += sight_action
    html += sight_default
    html += sight_guide

    return html   
    
  end

  def sight_note

    if !has_note then return "" end

    html = parse_wildcards(note)

    children.each do |vessel|
      html = html.sub(" #{vessel.name} "," #{vessel.to_s(false,false)} ")
    end

    return "<p class='note'>#{html}</p>"

  end

  def parse_wildcards text

    text.scan(/(?:\(\()([\w\W]*?)(?=\)\))/).each do |str,details|
      key = str.split(" ").first
      value = str.sub("#{key} ","").strip
      if Kernel.const_defined?("Wildcard#{key.capitalize}")
        wc = Object.const_get("Wildcard#{key.capitalize}").new(self,value)
        text = text.gsub("((#{str}))",wc.to_s)
      else
        text = text.gsub(str,"Error:#{key}.")
      end
    end

    return text

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

    hints = []

    # Statuses
    if is_locked then hints.push("The #{name} is locked, you may not modify it.") end
    if is_hidden then hints.push("The #{name} is hidden, you may not see its warp id.") end
    if is_quiet then hints.push("The #{name} is quiet, you may not see other's vessels.") end
    if is_frozen then hints.push("The #{name} is frozen, you may not interact with it.") end

    if hints.length > 0
      return "<ul class='guide code'><li>#{hints.last}</li></ul>"
    end

    hints = []

    # Check Validity
    validity_check, validity_errors = is_valid
    if validity_check == false then hints += validity_errors end
    validity_check, validity_errors = is_valid
    if validity_check == false then hints += validity_errors end

    if hints.length > 0
      html = ""
      hints.each do |hint|
        html += "<li>#{hint}</li>"
      end
      return "<ul class='guide alert'>#{html}</ul>"
    end

    # Own's
    if owner == id
      hints.push("Vessel is complete.")
      if !has_note then hints.push("Add a <action data-action='describe '>description</action> to the parent vessel.") end
      if !has_attr then hints.push("Add an <action data-action='transform '>attribute</action> to the parent vessel.") end
    # Improvements
    elsif !is_locked
      if !has_note then hints.push("Improve this vessel with a <action data-action='describe '>description</action>.") end
      if !has_attr then hints.push("Improve this vessel with an <action data-action='transform '>attribute</action>.") end
    end

    # All good!
    if hints.length < 1 then return "" end

    html = ""
    hints.each do |hint|
      html += "<li>#{hint}</li>"
    end
    return "<ul class='guide'>#{html}</ul>"

  end

end