#!/bin/env ruby
require_relative '_toolkit'

# Change vessel's name and attribute
class ActionTransform

  include Action

  def initialize(q = nil)

    super

    @name = 'Transform'
    @verb = 'Transforming'
    @docs = 'Change your current vessel name and attribute.'
    @examples = ['<b>transform</b> into a red bat <comment>You are a red bat.</comment>']

  end

  def act(params = '')

    parts = params.remove_articles.split(' ')
    name = parts.last
    attr = parts.length > 1 ? parts[parts.length - 2] : nil

    old_name = @host.name
    old_attr = @host.attr
    @host.name = name
    @host.attr = attr

    validity_check, validity_errors = @host.is_valid

    # Host name and attr needs to be set to the old values if it's not valid or unique any more
    unless validity_check
      @host.name = old_name
      @host.attr = old_attr
      return @host.answer(self, :error, validity_errors.first.to_s)
    end

    unless @host.is_unique
      @host.name = old_name
      @host.attr = old_attr
      a = attr == '' ? attr : "#{attr} "
      return @host.answer(self, :error, "Another #{a}#{name} already exists.")
    end

    if @host.is_locked
      @host.name = old_name
      @host.attr = old_attr
      return @host.answer(self, :error, "#{@host} is locked.")
    end

    @host.save

    @host.answer(self, :modal, "#{old_name} transformed into the #{@host}.")

  end

end
