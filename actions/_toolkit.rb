#!/bin/env ruby
# encoding: utf-8

module ActionToolkit
  
  def remove_articles words

    words = " #{words} ".sub(" the ","")
    words = " #{words} ".sub(" a ","")
    words = " #{words} ".sub(" an ","")
    words = " #{words} ".sub(" some ","")
    words = " #{words} ".sub(" one ","")
    words = " #{words} ".sub(" two ","")
    return words.strip

  end

  def is_unique name,attr

    $parade.each do |vessel|
      if vessel.name.like(name) && vessel.attr.like(attr) then return nil end
    end

    return true

  end

  def is_alphabetic word

    if word.gsub(/[^a-z]/i, '').downcase == word then return true end
    return nil

  end

  def is_long_enough word, min = 3,max = 14

    if word.length < min then return false end
    return true

  end

  def is_valid word

    $BADWORDS.each do |bad_word|
      if word.include?(bad_word) then return nil end
    end
    return true

  end

  

  def visible_named attr_name

    attr_name = remove_articles(attr_name).split

    target_name = attr_name.last
    target_attr = attr_name.length == 2 ? attr_name[attr_name.length-2] : ""

    @host.siblings.each do |vessel|
      if vessel.name.like(target_name) && vessel.attr.like(target_attr) then return vessel end
    end
    @host.children.each do |vessel|
      if vessel.name.like(target_name) && vessel.attr.like(target_attr) then return vessel end
    end
    @host.siblings.each do |vessel|
      if vessel.name.like(target_name) then return vessel end
    end
    @host.children.each do |vessel|
      if vessel.name.like(target_name) then return vessel end
    end

    return nil

  end

  def sibling_named attr_name

    attr_name = remove_articles(attr_name).split

    target_name = attr_name.last
    target_attr = attr_name.length == 2 ? attr_name[attr_name.length-2] : ""

    @host.siblings.each do |vessel|
      if vessel.name.like(target_name) && vessel.attr.like(target_attr) then return vessel end
    end
    @host.siblings.each do |vessel|
      if vessel.name.like(target_name) then return vessel end
    end
    return nil

  end

  def child_named attr_name

    attr_name = remove_articles(attr_name).split

    target_name = attr_name.last
    target_attr = attr_name.length == 2 ? attr_name[attr_name.length-2] : ""

    @host.children.each do |vessel|
      if vessel.name.like(target_name) && vessel.attr.like(target_attr) then return vessel end
    end
    @host.children.each do |vessel|
      if vessel.name.like(target_name) then return vessel end
    end
    return nil

  end

  def distant_id warp_id

    if warp_id.to_i < 1 || warp_id.to_i > 99999 then return nil end
    if !$parade[warp_id] then return nil end

    return $parade[warp_id]

  end

  def is_improvement before,after

    words_before = {}
    before.split(" ").each do |word|
      words_before[word] = words_before[word].to_i + 1
    end

    words_after = {}
    after.split(" ").each do |word|
      words_after[word] = words_after[word].to_i + 1
    end

    ratio = words_after.length.to_f / words_before.length.to_f

    if ratio < 0.2 then return nil end

    return true

  end

  def wildcard q

    if q.include?("(random ")
      string = q.split("(random ").last.split(")").first.strip
      params = string.split(" ")
      return q.sub("(random #{string})",params[rand(params.length)].to_s)
    end

    return q

  end

end
