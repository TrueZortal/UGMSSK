class GamesController < ApplicationController
  def start
    # @board = Board.new(8, uniform: false, starting_surface: 'grass')
    @match = Pvp.new(players: 2, board_size: 8, uniform: false, enable_randomness: false)
    @board = @match.game.board
  end
end