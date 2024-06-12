#!/bin/env ruby

# Used to perform all the actions a vessel can do to test for bugs.
class ActionDebug

  include Action

  def initialize

    super

    @name = 'Debug'
    @docs = 'Test paradise for errors.'

  end

  def act

    vessel = @host.parade[589]

    puts '------------------'
    puts "BASICS(#{vessel})"
    puts '------------------'

    # TODO: Need to add a way to delete the created node
    puts vessel.act('warp', '1')
    puts vessel.act('leave', '')
    puts vessel.act('enter', 'the book')
    puts vessel.act('create', 'a benchmark tool')
    puts vessel.act('enter', 'the tool')

    puts '------------------'
    puts "PARENT(#{vessel})"
    puts '------------------'

    'done.'

  end

end
