#!/bin/env ruby

# A Paradise comment
class Comment

  attr_accessor :id

  def initialize(content = {}, memory_index = -1)

    @content = content
    @memory_index = memory_index

  end

  def inject(host, message)

    @content['TIMESTAMP'] = Timestamp.new
    @content['HOST'] = host.memory_index
    @content['FROM'] = host.unde
    @content['MESSAGE'] = message

  end

  def host

    @content['HOST'].to_i

  end

  def from

    @content['FROM'].to_i

  end

  def message

    @content['MESSAGE'].to_s

  end

  def timestamp

    Timestamp.new(@content['TIMESTAMP'])

  end

  def vessel_name

    await_parade

    return 'ghost' unless $nataniev.vessels[:paradise].parade[from]

    vessel = $nataniev.vessels[:paradise].parade[from]
    "the #{vessel}"

  end

  def feedback

    return "You asked \"#{message}\"?" if is_question
    return "You shouted \"#{message}\"" if is_shout
    return "You #{message[3, message.length - 3]}." if is_emote
    return "You indicated <action-link data-action='warp to #{message}'>≡#{message.to_i}</action-link>." if is_warp

    "You said \"#{message}\"."

  end

  def to_s

    return "<li>#{vessel_name.capitalize} asked \"<message>#{message.capitalize}?</message>\".</li>" if is_question
    return "<li>#{vessel_name.capitalize} shouts \"<message>#{message.capitalize}</message>\".</li>" if is_shout
    return "<li>#{vessel_name.capitalize} <message>#{message[3, message.length - 3]}</message>.</li>" if is_emote

    m = message.to_i
    v = $nataniev.vessels[:paradise].parade[m]
    action_link = "<action-link data-action='warp to #{m}'>#{v}</action-link>"
    return "<li>#{vessel_name.capitalize} signals from the #{action_link}.</li>" if is_warp

    "<li>— \"<message>#{message.capitalize}</message>\", says #{vessel_name}.</li>"

  end

  def to_code

    "#{Timestamp.new} #{from.to_s.prepend('0', 5)} #{host.to_s.prepend('0', 5)} #{message}"

  end

  def is_valid

    return false, 'You said nothing.' if message == ''
    return false, "Please, don't shout." if message.upcase == message && message.to_i < 1

    non_alpha = message.downcase != message.gsub(/[^a-zZ-Z0-9\s!?.,']/i, '').downcase
    return false, 'Dialogs can only include alphanumeric characters and punctuation.' if non_alpha

    true

  end

  def is_question

    question_words = %w[are is does who what where when how why which]
    first_word = message.split(' ').first.to_s

    question_words.each do |word|

      return true if first_word.like(word)

    end

    false

  end

  def is_shout

    message[-1, 1] == '!'

  end

  def is_emote

    message[0, 3] == 'me '

  end

  def is_warp

    message.to_i.positive?

  end

  def is_repeated

    $nataniev.vessels[:paradise].forum.to_a(:comment).reverse[0, 1].each do |comment|

      return true if comment.message == message

    end
    false

  end

  def await_parade

    it = 0
    while it < 10 && (defined?($nataniev.vessels[:paradise].corpse).nil? || $nataniev.vessels[:paradise].corpse.nil?)
      puts 'Searching for corpse...'
      sleep 0.5
      it += 1
    end

    it = 0
    while it < 10 && (defined?($nataniev.vessels[:paradise].parade).nil? || $nataniev.vessels[:paradise].parade.nil?)
      puts 'Searching for parade...'
      sleep 0.5
      it += 1
    end

    nil

  end

end
