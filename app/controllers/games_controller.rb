# frozen_string_literal: true

class GamesController < ApplicationController
  def start
    @game = Game.new(current_turn:0)
    @game.save
    2.times do
      PvpPlayers.add_player(@game.id)
    end
    p @game.id
    @board = BoardState.create_board(game_id: @game.id, size_of_board_edge: 8)

    # if BoardState.count.zero?
    #   existing_board_state = ''
    #   @match = Pvp.new(players: 2, board_size: 8, uniform: false, enable_randomness: false,
    #                    board_json: existing_board_state)
    #   # @match.game.board.save_state
    # else
    #   existing_board_state = BoardState.order(created_at: :desc).first['board']
    #   @match = Pvp.new(enable_randomness: false, from_db: true, board_json: existing_board_state)
    # end

    # @board = @match.game.board
    # @game = @match.game

    # # if SummonedMinion.count.positive?
    #   SummonedMinion.all.each do |summoned_minion|
    #     if summoned_minion['health'].positive?
    #       @game.place(from_db: true, db_record: summoned_minion)
    #     else
    #       summoned_minion.destroy
    #     end
    #   end
    # end
    # PvpPlayers.where(game_id: game.id).each do |player|
    #   p player
    # end

    if TurnTracker.all.empty?
      PvpPlayers.where(game_id: @game.id).each do |player|
        # p player
        player_turn = TurnTracker.new(player_id: player['id'])
        player_turn.save
      end
    end
    popped_player = TurnTracker.first
    p TurnTracker.all

    @current_player = PvpPlayers.find(popped_player['player_id'])
  end

  def reset
    BoardState.destroy_all
    BoardField.destroy_all
    PvpPlayers.destroy_all
    SummonedMinion.destroy_all
    EventLog.destroy_all
    TurnTracker.destroy_all
    Game.destroy_all
    # PvpPlayers.connection.execute('ALTER SEQUENCE pvp_players_id RESTART WITH 0')
    redirect_to root_url
  end

  def start_game

  end


end
