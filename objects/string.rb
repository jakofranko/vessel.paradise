#!/bin/env ruby

# Add utilities to remove article words and to use Wildcard syntax.
# Wild cards are strings in vessel notes like ((vessel name)) that will
# print dynamic values. Allows vessels to have a bit mor life to them.
class String

  def wildcards(host)

    text = self
    text.scan(/(?:\(\()([\w\W]*?)(?=\)\))/).each do |str, _details|

      key = str.split(' ').first
      value = str.sub("#{key} ", '').strip
      if Kernel.const_defined?("Wildcard#{key.capitalize}")
        wc = Object.const_get("Wildcard#{key.capitalize}").new(host, value)
        text = text.gsub("((#{str}))", wc.to_s)
      else
        text = text.gsub(str, "Error:#{key}.")
      end

    end
    text

  end

  def remove_articles

    text = " #{self} "
    text = " #{text} ".gsub(' into ', ' ')
    text = " #{text} ".gsub(' some ', ' ')
    text = " #{text} ".gsub(' the ', ' ')
    text = " #{text} ".gsub(' one ', ' ')
    text = " #{text} ".gsub(' two ', ' ')
    text = " #{text} ".gsub(' a ', ' ')
    text = " #{text} ".gsub(' an ', ' ')
    text = " #{text} ".gsub(' to ', ' ')
    text = " #{text} ".gsub(' in ', ' ')
    text.strip

  end

end

