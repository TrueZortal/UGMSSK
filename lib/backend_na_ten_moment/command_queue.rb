# frozen_string_literal: true

# list of string commands to be executed for test automation/game loop recreation
class CommandQueue
  def initialize(array_of_commands = [])
    @queue = []
    bulk_add(array_of_commands)
  end

  def empty?
    @queue.empty?
  end

  def bulk_add(array_of_commands)
    array_of_commands.each do |command|
      add(command)
    end
  end

  def add(string_element)
    @queue << string_element
  end

  def size
    @queue.size
  end

  def pop
    @queue.shift
  end

  def clear
    @queue = []
  end
end
