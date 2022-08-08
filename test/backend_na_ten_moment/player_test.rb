# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../player'

class PlayerTest < Minitest::Test
  def test_a_new__instance_of_player_can_be_created
    test_player = Player.new
    assert_instance_of Player, test_player
  end

  def test_a_new_named_instance_of_player_can_be_created
    test_player = Player.new(name: 'Mateusz')
    assert_equal 'Mateusz', test_player.name
  end

  def test_a_new_player_can_have_a_mana_pool_assigned_and_the_pool_can_have_a_value
    test_player = Player.new(name: 'Mateusz', mana: 10)
    assert_instance_of ManaPool, test_player.manapool
    assert_equal 10, test_player.mana
  end

  def test_minion_list_returns_an_empty_list_if_no_minions
    test_player = Player.new(name: 'Mateusz', mana: 10)
    test_status = test_player.status
    expected_status = "\nMana:10/10 \nCurrent Minions: none"
    assert_equal expected_status, test_status
  end
end
