# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../render_board'
require_relative '../game'
require_relative '../board'

class RenderBoardTest < Minitest::Test
  def test_correctly_renders_2_x_2_board
    # skip
    test = Board.new(2)
    test_output = StringIO.new(test.render_board)
    value = "  0 1\n0 🟩🟩\n1 🟩🟩"
    assert_equal value, test_output.string
  end

  def test_correctly_renders_3_x_3_board
    # skip
    test = Board.new(3)
    test_output = StringIO.new(test.render_board)
    value = "  0 1 2\n0 🟩🟩🟩\n1 🟩🟩🟩\n2 🟩🟩🟩"
    assert_equal value, test_output.string
  end

  def test_a_placed_minion_renders_with_its_first_letter_as_symbol_and_owner_name
    # skip
    test_game = Game.new(2)
    test_game.add_player('1', max_mana: 5, summoning_zone: [[0, 0], [0, 1], [1, 0], [1, 1]])
    skelly = test_game.place(owner: '1', type: 'skeleton', x: 1, y: 0)
    test_output = StringIO.new(test_game.board.render_board)
    # puts test_game.board.render_board
    value = "  0 1\n0 🟩s1\n1 🟩🟩"
    assert_equal value, test_output.string
  end

  def test_a_minions_are_placed_in_the_correct_rendered_positions
    # skip
    test_game = Game.new(4)
    test_game.add_player('1', max_mana: 12,
                              summoning_zone: [[0, 0], [0, 1], [0, 2], [0, 3], [1, 0], [1, 1], [1, 2], [1, 3], [2, 0], [2, 1], [2, 2], [2, 3], [3, 0], [3, 1], [3, 2], [3, 3]])
    test_game.place(owner: '1', type: 'skeleton', x: 3, y: 0)
    test_game.place(owner: '1', type: 'skeleton', x: 3, y: 1)
    test_game.place(owner: '1', type: 'skeleton', x: 3, y: 2)
    test_game.place(owner: '1', type: 'skeleton', x: 3, y: 3)
    test_game.place(owner: '1', type: 'skeleton', x: 0, y: 0)
    test_game.place(owner: '1', type: 'skeleton', x: 0, y: 1)
    test_game.place(owner: '1', type: 'skeleton', x: 0, y: 2)
    test_game.place(owner: '1', type: 'skeleton', x: 0, y: 3)
    test_game.place(owner: '1', type: 'skeleton', x: 1, y: 0)
    test_game.place(owner: '1', type: 'skeleton', x: 2, y: 0)
    test_game.place(owner: '1', type: 'skeleton', x: 1, y: 3)
    test_game.place(owner: '1', type: 'skeleton', x: 2, y: 3)
    test_output = StringIO.new(test_game.board.render_board)
    value = "  0 1 2 3\n0 s1s1s1s1\n1 s1🟩🟩s1\n2 s1🟩🟩s1\n3 s1s1s1s1"
    assert_equal value, test_output.string
  end
end
