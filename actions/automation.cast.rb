#!/bin/env ruby
require_relative '_toolkit'

# Perform actions on distant vessels
class ActionCast

  include Action

  def initialize(q = nil)

    super

    @name = 'Cast'
    @docs = "Use a vessel program's from anywhere. "\
            'By default, the spell will be cast onto the current active vessel, '\
            'casting can also target a visible vessel.'
    @verb = 'Casting'
    @examples = ['<b>cast</b> the vanish spell <comment>You are invisible.</comment>',
                 '<b>cast</b> the vanish spell <b>on</b> the purple bat']

  end

  def act(params = '')

    if params.include?(' on ')
      s = params.split(' on ')
      cast_proxy(s.first, s.last)
    else
      cast_default(params)
    end

  end

  def cast_default(spell_name)

    spell = @host.find_distant(spell_name)

    return @host.answer(self, :error, 'This spell is unknown.') unless spell
    return @host.answer(self, :error, "#{spell} is not a valid spell.") unless spell.program.is_valid
    return @host.answer(self, :error, 'Cannot cast a casting program.') if spell.program.action.like('cast')

    @host.act(spell.program.action, spell.program.params.wildcards(@host))

  end

  def cast_proxy(spell_name, target_name)

    spell = @host.find_distant(spell_name)
    target = @host.find_visible(target_name)

    return @host.answer(self, :error, 'This spell is unknown.') unless spell
    return @host.answer(self, :error, "#{spell} is not a valid spell.") unless spell.program.is_valid
    return @host.answer(self, :error, 'The target vessel is not valid.') unless target
    return @host.answer(self, :error, 'Cannot cast a casting program.') if spell.program.action.like('cast')

    target.act(spell.program.action, spell.program.params.wildcards(target))

  end

end
