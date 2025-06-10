#!/bin/env ruby
require_relative '_toolkit'

# Move across a distance
class ActionWarp

  include Action

  def initialize(q = nil)

    super

    @name = 'Warp'
    @verb = 'Warping'
    @docs = 'Enter a distant vessel by either its name, or its warp id. The vessel must be visible.'
    @examples = [
      '<b>warp</b> to the library <comment>You entered the library.</comment>',
      '<b>warp</b> to 1 <comment>You entered the library.</comment>'
    ]

  end

  def act(params = '')

    target_id = params.split(' ').last.to_i

    return @host.answer(self, :error, "#{topic} are not allowed to warp in negative nullspace.") if target_id.negative?

    target = @host.find_distant(target_id.to_s)
    prev = @host.parent

    return @host.answer(self, :error, "#{@host} is locked.") if @host.is_locked
    return @host.answer(self, :error, "#{topic} may not warp into nullspace.") if !target || target_id.zero?
    return @host.answer(self, :error, "#{target} cannot be warped into.") if target.is_hidden
    return @host.answer(self, :error, "#{topic} already in #{target}.") if target.memory_index == prev.memory_index

    @host.set_unde(target_id)

    @host.answer(self, :modal, "#{topic} left the #{prev} and warped to the #{target}.")

  end

end
