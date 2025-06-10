#!/bin/env ruby
$nataniev.require('corpse', 'http')

# A strange action, seems to just grab the most recent 10 messages
# from the forum. Might be away to interact with the Paradise forum
# from the CLI without having to log in?
class ActionQuery

  include Action

  def initialize(q = nil)

    super

    @name = 'Query'
    @docs = 'Deliver the Paradise API.'

  end

  def act(_q = nil)

    load_folder("#{@host.path}/objects/*")
    load_folder("#{@host.path}/vessels/*")
    load_folder("#{@host.path}/actions/*")

    $nataniev.vessels[:paradise].forum = Memory_Array.new('forum', @host.path)

    a = []
    Memory_Array.new('forum', @host.path).to_a.reverse[0, 10].each do |message|

      a.push({
               time: message['TIMESTAMP'],
               host: message['HOST'],
               from: message['FROM'],
               text: message['MESSAGE']
             })

    end

    a.to_json

  end

end
