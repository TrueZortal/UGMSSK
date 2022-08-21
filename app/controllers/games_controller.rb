# frozen_string_literal: true

class GamesController < ApplicationController
  def start
    if BoardState.count.zero?
      existing_board_state = ''
      @match = Pvp.new(players: 2, board_size: 8, uniform: false, enable_randomness: false,
                       board_json: existing_board_state)
      @match.game.board.save_state
    else
      existing_board_state = BoardState.order(created_at: :desc).first['board']
      @match = Pvp.new(enable_randomness: false, from_db: true, board_json: existing_board_state)
    end

    @board = @match.game.board
    @game = @match.game

    if SummonedMinion.count.positive?
      SummonedMinion.all.each do |summoned_minion|
        @game.place(from_db: true, db_record: summoned_minion)
      end
    end
    # @game.place(owner: 'Player1', type: 'skeleton', x: 0, y: 0)
    # @game.place(owner: 'Player2', type: 'skeleton archer', x: 1, y: 1)
    # @game.place(owner: 'Player1', type: 'skeleton archer', x: 2, y: 2)
    # @game.place(owner: 'Player1', type: 'skeleton', x: 0, y: 2)

  end

  def reset
    BoardState.destroy_all
    PvpPlayers.destroy_all
    SummonedMinion.destroy_all
    EventLog.destroy_all
    # PvpPlayers.connection.execute('ALTER SEQUENCE pvp_players_id RESTART WITH 0')
    redirect_to root_url
  end

  def add_player
    if PvpPlayers.all.size >= 2 && PvpPlayers.all.size < 4
      added_player = PvpPlayers.new(name: "Player#{PvpPlayers.all.size + 1}", mana: 10, max_mana: 10,
                                    summoning_zone: '')
      added_player.save
    end
    redirect_to root_url
  end

  def remove_player
    PvpPlayers.last.destroy if PvpPlayers.all.size > 2 && PvpPlayers.all.size <= 4
    redirect_to root_url
  end
end
