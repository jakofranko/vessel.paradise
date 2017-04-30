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

end