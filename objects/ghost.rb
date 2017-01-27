#!/bin/env ruby
# encoding: utf-8

class Ghost

  include Vessel

  def initialize content

    super

    @content = content

    @name = @content["NAME"]
    @attr = @content["ATTR"]
    @type,@unde,@time = @content["CODE"].split("-")
    @unde = @unde.to_i

    @path = File.expand_path(File.join(File.dirname(__FILE__), "/"))
    @docs = "Default Paradise vessel."
    
    install(:paradise,:look)
    install(:generic,:help)

  end

  def parent

    return $paradise[@unde]

  end

  def to_s

    return "#{@attr} #{@name}"

  end

end