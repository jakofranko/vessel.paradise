#!/bin/env ruby
require_relative '_toolkit'

# Make a new vessel
class ActionCreate

  include Action

  def initialize(q = nil)

    super

    @name = 'Create'
    @verb = 'Creating'
    @docs = 'Create a new vessel at your current location. '\
            'Vessel names and attributes must include less than 14 characters and be unique. '
    @examples = ['<b>create</b> a black cat <comment>You see a black cat.</comment>']

  end

  def act(params = '')

    parts = params.remove_articles.split(' ')
    name = parts.last
    attr = parts.length > 1 ? parts[parts.length - 2] : ''
    unde = @host.unde.to_s.prepend('0', 5)
    mem_i = @host.memory_index.to_s.prepend('0', 5)

    new_vessel = Teapot.new({
                              'NAME' => name.downcase,
                              'ATTR' => attr.downcase,
                              'CODE' => "0000-#{unde}-#{mem_i}-#{Timestamp.new}"
                            }, -1)

    validity_check, validity_errors = new_vessel.is_valid

    return @host.answer(self, :error, validity_errors.first.to_s) unless validity_check
    return @host.answer(self, :error, "Another #{new_vessel} vessel already exists.") unless new_vessel.is_unique

    $nataniev.vessels[:paradise].paradise.append(new_vessel.encode)

    # The new vessel is now a sibling of the @host, so they need to be reloaded
    @host.reset_siblings

    @host.answer(self, :modal, "#{topic} created the #{new_vessel}.")

  end

end
