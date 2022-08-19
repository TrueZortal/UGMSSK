# frozen_string_literal: true

require_relative 'game'
require_relative 'turn'
require_relative 'input'
require_relative 'output'

class Pvp
  attr_accessor :game

  def initialize(players: 2, board_size: 8, uniform: false, enable_randomness: true, from_db: false, board_json: '')
    @game = if from_db
              Game.new(board_size, uniform: false, board_json: board_json)
            else
              Game.new(board_size, uniform: false)
            end
    @random = enable_randomness

    if from_db
        PvpPlayers.all.each do |player|
          if @random
            @game.add_player(from_db: true, db_record: player)
          else
            @game.add_player(summoning_zone: @game.board.array_of_coordinates, from_db: true, db_record: player)
          end
        end
    else
      @players = players
      populate_players

    end
    # show_boardstate
    # gameplay_loop
    # resolve_skirmish
  end

  private

  def populate_players
    @players.times do |index|
      # puts "enter P#{index + 1} name"
      # name = Input.get_raw
      name = "Player#{index + 1}"
      # puts "enter P#{index + 1} maximum mana"
      # mana = Input.get.to_i
      mana = 10
      if @random
        @game.add_player(player_name: name, max_mana: mana)
      else
        @game.add_player(player_name: name, max_mana: mana, summoning_zone: @game.board.array_of_coordinates)
      end
    end
  end

  def resolve_skirmish
    winner = @game.remaining_players
    if winner.empty?
      puts "it's a draw. Would you like to see the combat log? yes/no"
      query_log_view
    elsif @game.there_can_be_only_one
      puts "#{winner[0].name} is victorious, would you like to see the combat log? yes/no" # save it in a file for later gloating"
    end
    query_log_view
  end

  def query_log_view
    log_query = Input.get
    case log_query
    when 'yes'
      puts @game.log.print
    when 'no'
      exit!
    else
      puts 'invalid entry please select yes/no'
      query_log_view
    end
  end

  def gameplay_loop
    until @game.there_can_be_only_one
      set_turn_order
      Turn.new(@game, @order)
    end
  end

  def show_boardstate
    puts @game.board.render_board
  end

  def puts(string)
    Output.new.print(string)
  end

  def set_turn_order
    @order = if @random
               @game.players.shuffle
             else
               @game.players
             end
  end
end

# Pvp.new(players: 2, board_size: 8, uniform: false, enable_randomness: false)
