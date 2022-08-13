# frozen_string_literal: true

class GamesController < ApplicationController
  def start
    # @board = Board.new(8, uniform: false, starting_surface: 'grass')
    @match = Pvp.new(players: 2, board_size: 12, uniform: false, enable_randomness: false)
    @board = @match.game.board
    @game = @match.game
    # @game.place(owner: 'Player1', type: 'skeleton', x: 0, y: 0, board_fields: @board)
    # @game.place(owner: 'Player2', type: 'skeleton archer', x: 1, y: 1, board_fields: @board)
    # p @game.board.make_json
    # @game.place(owner: 'Player1', type: 'skeleton archer', x: 1, y: 1, board_fields:  @board)
    # @game.place(owner: 'Player1', type: 'skeleton', x: 0, y: 2, board_fields:  @board)
  end
end
