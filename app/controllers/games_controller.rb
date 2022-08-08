class GamesController < ApplicationController
  def start
    @board = Board.new(8, uniform: false, starting_surface: 'grass')
    # @board.render_board
    # list_of_test_inputs = %w[PVP 4 8 cool M 10 T 10 Z 10 Q 10 concede concede concede
    #   concede no]
    # Menu.instance.command_queue.bulk_add(list_of_test_inputs)
    # Menu.instance.display_menu
    @content = "cokolwiek albo dupa"
  end
end