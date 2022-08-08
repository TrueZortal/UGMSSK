# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../position'

class PositionTest < Minitest::Test
  def test_can_create_a_new_position
    test_position = Position.new(2, 3)
    assert_equal 2, test_position.x
    assert_equal 3, test_position.y
    assert_equal [2, 3], test_position.to_a
  end

  def test_can_compare_if_two_positions_are_overlapping
    test_position = Position.new(2, 3)
    other_position = Position.new(2, 3)
    assert_equal true, test_position == other_position
  end

  def test_can_correctly_calculate_distance
    test_position = Position.new(2, 3)
    other_position = Position.new(3, 4)
    otherer_position = Position.new(4, 5)
    assert_equal Math.sqrt(2), test_position.distance(other_position)
    assert_equal Math.sqrt(8), test_position.distance(otherer_position)
  end

  def test_gets_route_correctly_on_x_axis
    starting_position = Position.new(0, 0)
    other_position = Position.new(3, 0)
    expected = [[2, 0], [1, 0]]
    assert_empty(expected - starting_position.get_route_to(other_position))
  end

  def test_gets_route_correctly_on_y_axis
    # skip
    starting_position = Position.new(4, 4)
    other_position = Position.new(4, 7)
    expected = [[4, 5], [4, 6]]
    assert_empty(expected - starting_position.get_route_to(other_position))
  end

  def test_gets_route_correctly_on_across_axis
    # skip
    starting_position = Position.new(3, 3)
    other_position = Position.new(8, 8)
    expected = [[4, 4], [5, 5], [6, 6], [7, 7]]
    assert_empty(expected - starting_position.get_route_to(other_position))
  end

  def test_gets_route_correctly_somewhat_across_but_more_y_axis
    # skip
    starting_position = Position.new(0, 0)
    other_position = Position.new(1, 2)
    expected = [[0, 1]]
    assert_empty(expected - starting_position.get_route_to(other_position))
  end

  def test_gets_route_correctly_somewhat_across_but_more_x_axis
    # skip
    starting_position = Position.new(0, 0)
    other_position = Position.new(2, 1)
    expected = [[1, 0]]
    assert_empty(expected - starting_position.get_route_to(other_position))
  end

  def test_gets_route_correctly_on_x_axis_but_reverse
    # skip
    starting_position = Position.new(3, 0)
    other_position = Position.new(0, 0)
    expected = [[2, 0], [1, 0]]
    assert_empty(expected - starting_position.get_route_to(other_position))
  end

  def test_gets_route_correctly_on_y_axis_but_reverse
    # skip
    starting_position = Position.new(4, 7)
    other_position = Position.new(4, 4)
    expected = [[4, 5], [4, 6]]
    assert_empty(expected - starting_position.get_route_to(other_position))
  end

  def test_gets_route_correctly_on_across_axis_but_reverse
    # skip
    starting_position = Position.new(8, 8)
    other_position = Position.new(3, 3)
    expected = [[4, 4], [5, 5], [6, 6], [7, 7]]
    assert_empty(expected - starting_position.get_route_to(other_position))
  end

  def test_gets_route_correctly_somewhat_across_but_more_y_axis_but_reverse
    # skip
    starting_position = Position.new(1, 2)
    other_position = Position.new(0, 0)
    expected = [[1, 1]]
    assert_empty(expected - starting_position.get_route_to(other_position))
  end

  def test_gets_route_correctly_somewhat_across_but_more_x_axis_but_reverse
    # skip
    starting_position = Position.new(2, 1)
    other_position = Position.new(0, 0)
    expected = [[1, 1]]
    assert_empty(expected - starting_position.get_route_to(other_position))
  end
end
