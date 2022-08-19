# frozen_string_literal: true

class GamesController < ApplicationController
  def start
    existing_board_state = if BoardState.count.zero?
                             ''
                           else
                             BoardState.order(created_at: :desc).first['board']
                           end
    @match = Pvp.new(players: 2, board_size: 8, uniform: false, enable_randomness: false,
                     board_json: existing_board_state)
    @board = @match.game.board
    @game = @match.game
    # @game.place(owner: 'Player1', type: 'skeleton', x: 0, y: 0)
    # @game.place(owner: 'Player2', type: 'skeleton archer', x: 1, y: 1)
    # @game.place(owner: 'Player1', type: 'skeleton archer', x: 2, y: 2)
    # @game.place(owner: 'Player1', type: 'skeleton', x: 0, y: 2)
    @board.save_state
  end

  def reset
    BoardState.destroy_all
    PvpPlayers.destroy_all
    # PvpPlayers.connection.execute('ALTER SEQUENCE pvp_players_id RESTART WITH 0')
    redirect_to root_url
  end

  def add_player
    added_player = PvpPlayers.new(name:"Player#{PvpPlayers.all.size + 1}", mana: 10, max_mana: 10, summoning_zone:'')
    added_player.save

    redirect_to root_url
  end

  def remove_player
    PvpPlayers.last.destroy

    redirect_to root_url
  end
  # def save_state(state)
  #   # @board = BoardState.find(params[:board])
  #   # current = BoardState.new(board: board.make_json)
  #   state.save
  #   redirect_to root_url
  # end

  # this needs to be implemented via database with player state
  # def add_player
  #   p @game
  #   @game.add_player(name: "Player#{@game.players.size+1}", max_mana: 10)
  #   redirect_to root_url
  # end
end
