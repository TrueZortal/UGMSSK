# frozen_string_literal: true

require 'singleton'
require_relative 'pvp'
require_relative 'input'
require_relative 'output'
require_relative 'command_queue'

class Menu
  include Singleton
  attr_accessor :command_queue

  def initialize
    @command_queue = CommandQueue.new
  end

  def display_menu
    puts 'Welcome to Ultimate Giga Master Super Summoner King'
    puts "PVP\nexit"
    menu_loop
  end

  def menu_loop
    ans = get_input
    case ans
    when 'pvp'
      start_pvp
    when 'debug_pvp'
      start_debug_pvp
    when 'exit'
      exit!
    else
      display_menu
    end
  end

  def start_pvp
    puts 'how many players will be playing?'
    players = get_input.to_i
    puts 'how big would you like the board?'
    board_size = get_input.to_i
    puts 'would you like a cool board or a boring one? cool/boring'
    board_type = get_input
    uniform = case uniform
              when 'boring'
                true
              else
                false
              end
    PVP.new(players: players, board_size: board_size, uniform: uniform)
  # rescue StandardError
  #   puts 'game crashed, restarting'
  #   retry
  end

  def start_debug_pvp
    puts 'how many players will be playing?'
    players = get_input.to_i
    puts 'how big would you like the board?'
    board_size = get_input.to_i
    puts 'would you like a cool board or a boring one? cool/boring'
    board_type = get_input
    uniform = true
    PVP.new(players: players, board_size: board_size, uniform: uniform, enable_randomness: false)
  # rescue StandardError
  #   puts 'game crashed, restarting'
  #   retry
  end

  def get_input
    Input.get
  end

  def puts(string)
    Output.new.print(string)
  end

  def self.instance
    @instance ||= new
  end
end
