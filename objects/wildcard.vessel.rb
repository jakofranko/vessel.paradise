#!/bin/env ruby
require_relative 'wildcard'

# Display data about the current vessel
class WildcardVessel

  include Wildcard

  def initialize(host = nil, value = nil)

    super

    @docs = 'Displays current vessel or parent vessel details.'
    @options = [
      'id',
      'name',
      'attr',
      'parent id',
      'parent name',
      'parent attr',
      'stem id',
      'stem name',
      'stem attr',
      'random id',
      'random name',
      'random attr'
    ]

  end

  def to_s

    target_name = @value.split(' ').first
    target = @host

    target = @host.parent if target_name.like('parent')
    target = @host.stem if target_name.like('stem')
    target = @host.find_random if target_name.like('random')

    target_detail = @value.split(' ').last

    return target.memory_index.to_s if target_detail.like('id') && !target.is_hidden
    return target.stem if target_detail.like('stem')
    return target.name if target_detail.like('name')
    return target.attr if target_detail.like('attr')

    '?'

  end

end
