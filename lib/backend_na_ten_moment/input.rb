# frozen_string_literal: true

require_relative 'command_queue'
require_relative 'menu'

class Input
  def initialize(input: $stdin)
    @input = input
    @command_queue = Menu.instance.command_queue
  end

  def get
    call_gets
  end

  def self.get(input: $stdin)
    new(input: input).call_gets.downcase
  end

  def self.get_raw(input: $stdin)
    new(input: input).call_gets
  end

  def self.get_position(input: $stdin)
    new(input: input).call_gets.split(',')
  end

  def call_gets
    if @command_queue.empty?
      @input.gets.chomp
    else
      @command_queue.pop
    end
  end
end
