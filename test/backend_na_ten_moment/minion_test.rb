# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../minion'

class MinionTest < Minitest::Test
  def test_can_create_a_new_minion_object_without_type_and_space
    skelly = Minion.new
    assert_nil skelly.position.x
    assert_nil skelly.position.y
  end

  def test_cant_create_a_new_minion_with_a_negative_coordinate_x
    assert_raises(InvalidPositionError) do
      skelly = Minion.new(x: -1)
    end
  end

  def test_cant_create_a_new_minion_with_a_negative_coordinate_y
    assert_raises(InvalidPositionError) do
      skelly = Minion.new(y: -1)
    end
  end

  def test_minion_can_be_placed_anywhere_if_not_connected_to_a_board
    skelly = Minion.new(x: 7, y: 1000)
    assert_equal 1000, skelly.position.y
  end

  def test_minion_can_be_assigned_an_owner
    skelly = Minion.new(owner: 'Mateusz')
    assert_equal 'Mateusz', skelly.owner
  end

  def test_a_skeleton_minion_has_correct_default_values_when_created
    # skip
    skelly = Minion.new(type: 'skeleton')
    assert_equal 1, skelly.attack
    assert_equal 0, skelly.defense
    assert_equal 5, skelly.health
    assert_equal 2, skelly.speed
  end

  def test_cant_create_a_minion_of_non_existent_type
    assert_raises(ArgumentError) do
      skelly = Minion.new(type: 'tomato')
    end
  end

  def test_minion_status_reports_correctly
    skelly = Minion.new(type: 'skeleton', x: 1, y: 1)
    enemy = Minion.new(type: 'skeleton', x: 1, y: 2)
    skelly.attack_action(enemy)
    expected_enemy_status = { pos: [1, 2], type: 'skeleton', hp: '4/5', attack: 1, defense: 0 }
    expected_skelly_status = { pos: [1, 1], type: 'skeleton', hp: '5/5', attack: 1, defense: 0 }
    assert_equal expected_enemy_status, enemy.status
    assert_equal expected_skelly_status, skelly.status
  end
end
