# frozen_string_literal: true

class GamesController < ApplicationController
  def start
    # @board = Board.new(8, uniform: false, starting_surface: 'grass')
    tablica_z_bazy = if BoardState.count.zero?
                       ''
                     else
                       BoardState.order(created_at: :desc).first['board']
                     end
    @match = Pvp.new(players: 2, board_size: 8, uniform: false, enable_randomness: false, board_json: tablica_z_bazy)
    @board = @match.game.board
    @game = @match.game
    # @game.place(owner: 'Player1', type: 'skeleton', x: 0, y: 0)
    # @game.place(owner: 'Player2', type: 'skeleton archer', x: 1, y: 1, board_fields: @board)
    # p @game.board.make_json
    # @game.place(owner: 'Player1', type: 'skeleton archer', x: 1, y: 1, board_fields:  @board)
    # @game.place(owner: 'Player1', type: 'skeleton', x: 0, y: 2, board_fields:  @board)
  end

  def reset
    BoardState.destroy_all
    p 'guzik dziala'
    redirect_to root_url
  end
end
