# frozen_string_literal: true

class GamesController < ApplicationController
  def start
    if Game.all.empty?
      @game = Game.new(current_turn: 0)
      @game.save
      2.times do
        PvpPlayers.add_player(@game.id)
      end
      p @game.player_ids
      @board = BoardState.create_board(game_id: @game.id, size_of_board_edge: 8)
    else
      @game = Game.last
    end

    # p TurnTracker.pull_current_player(game_record: @game)

    #   PvpPlayers.where(game_id: @game.id).each do |player|
    #     # p player
    #     player_turn = TurnTracker.new(player_id: player['id'])
    #     player_turn.save
    #   end
    # end
    # popped_player = TurnTracker.first
    # TurnTracker.first.destroy
    # p TurnTracker.all

    @current_player = PvpPlayers.find(TurnTracker.pull_current_player_id(game_id: @game.id))
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

  def start_game; end
end

# create_table "turn_trackers", force: :cascade do |t|
#   t.integer "game_id"
#   t.integer "turn_number"
#   t.boolean "complete", default: false
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   t.integer "player_id"
# end
