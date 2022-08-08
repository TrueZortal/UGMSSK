# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../board'
require_relative '../minion'
require_relative '../field'

class BoardTest < Minitest::Test
  def test_cant_create_a_board_without_an_argument
    assert_raises(ArgumentError) do
      Board.new
    end
  end

  def test_cant_create_a_board_smaller_than_2_x_2
    assert_raises(ArgumentError) do
      Board.new(1)
    end
  end

  def test_creates_a_custom_sized_board
    test = Board.new(5)
    assert_equal 25, test.rowified_board.flatten.size
  end

  def test_board_gives_correct_limit
    test = Board.new(8)
    assert_equal 7, test.upper_limit
  end

  def test_board_correctly_identifies_starting_zones_and_acreage
    test = Board.new(8)
    expected = 'Your summoning zone is top left and has a size of 2x2 squares'
    zone = [[0, 0], [1, 1]]
    assert_equal expected, test.zone_message(zone)
  end
end
