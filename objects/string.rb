#!/bin/env ruby
# encoding: utf-8

class String

  def wildcards host

    text = self
    text.scan(/(?:\(\()([\w\W]*?)(?=\)\))/).each do |str,details|
      key = str.split(" ").first
      value = str.sub("#{key} ","").strip
      if Kernel.const_defined?("Wildcard#{key.capitalize}")
        wc = Object.const_get("Wildcard#{key.capitalize}").new(host,value)
        text = text.gsub("((#{str}))",wc.to_s)
      else
        text = text.gsub(str,"Error:#{key}.")
      end
    end
    return text

  end

  def remove_articles

    text = " #{self} "
    text = " #{text} ".sub(" into ","")
    text = " #{text} ".sub(" some ","")
    text = " #{text} ".sub(" the ","")
    text = " #{text} ".sub(" one ","")
    text = " #{text} ".sub(" two ","")
    text = " #{text} ".sub(" a ","")
    text = " #{text} ".sub(" an ","")
    text = " #{text} ".sub(" to ","")
    text = " #{text} ".sub(" in ","")
    return text.strip

  end

end