# frozen_string_literal: true

require 'minitest/autorun'
# require_relative 'minion'

class MinionTest < Minitest::Test
  def test_minion_can_be_placed_anywhere_if_not_connected_to_a_board
    skelly = Minion.new(x: 7, y: 1000)
    assert_equal 1000, skelly.position.y
  end

  def test_minion_can_be_assigned_an_owner
    skelly = Minion.new(owner: 'Mateusz',x:0,y:0)
    assert_equal 'Mateusz', skelly.owner
  end

  def test_a_skeleton_minion_has_correct_default_values_when_created
    # skip
    skelly = Minion.new(type: 'skeleton',x:0,y:0)
    assert_equal 1, skelly.attack
    assert_equal 0, skelly.defense
    assert_equal 5, skelly.health
    assert_equal 2, skelly.speed
  end

  def test_cant_create_a_minion_of_non_existent_type
    assert_raises(ArgumentError) do
      Minion.new(type: 'tomato')
    end
  end

  def test_minion_status_reports_correctly
    skelly = Minion.new(type: 'skeleton', x: 1, y: 1)
    enemy = Minion.new(type: 'skeleton', x: 1, y: 2)
    skelly.attack_action(enemy)
    expected_enemy_status = { pos: [1, 2], type: 'skeleton', hp: '4/5'}
    expected_skelly_status = { pos: [1, 1], type: 'skeleton', hp: '5/5'}
    assert_equal expected_enemy_status, enemy.status
    assert_equal expected_skelly_status, skelly.status
  end

  def test_minion_can_be_recreated_from_json
    minion_json = Minion.new(x:0,y:0).make_json
    test_minion = Minion.new(minion_json: minion_json)
    assert_equal test_minion.make_json, minion_json
  end
end
