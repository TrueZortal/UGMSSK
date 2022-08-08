# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../game'
require_relative '../minion'
require_relative '../field'

class GameTest < Minitest::Test
  def test_a_minion_can_be_placed_on_board
    # skip
    test_game = Game.new(3)
    test_game.add_player('P1', max_mana: 5,
                               summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    skelly = test_game.place(owner: 'P1', type: 'skeleton', x: 1, y: 2)
    assert_equal 1, skelly.position.x
    assert_equal 2, skelly.position.y
    assert_equal skelly, test_game.board.check_field(Position.new(skelly.position.x, skelly.position.y)).occupant
  end

  def test_a_minion_cant_be_placed_out_of_bounds
    # skip
    test_game = Game.new(3)
    test_game.add_player('P1', max_mana: 5)
    assert_raises(InvalidPositionError) do
      test_game.place(owner: 'P1', type: 'skeleton', x: 3, y: 2)
    end
  end

  def test_a_minion_that_was_placed_exists_on_the_board
    # skip
    test_game = Game.new(3)
    test_game.add_player('P1', max_mana: 5,
                               summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    skelly = test_game.place(owner: 'P1', type: 'skeleton', x: 2, y: 2)
    test_field = Position.new(2, 2)
    assert_equal skelly, test_game.board.check_field(test_field).occupant
  end

  def test_a_minion_can_move_from_a_field_to_a_field_and_does_not_exist_in_two_places_at_once
    # skip
    test_game = Game.new(3)
    test_game.add_player('P1', max_mana: 5,
                               summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    skellys_first_position = Position.new(1, 1)
    skelly = test_game.place(owner: 'P1', type: 'skeleton', x: 1, y: 1)
    target_field = Position.new(2, 2)
    test_game.move(skelly.position, target_field)
    assert_equal skelly, test_game.board.check_field(target_field).occupant
    assert_equal '', test_game.board.check_field(skellys_first_position).occupant
  end

  def test_a_minions_position_updates_as_it_moves
    test_game = Game.new(3)
    test_game.add_player('P1', max_mana: 5,
                               summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    skellys_first_position = Position.new(1, 1)
    skelly = test_game.place(owner: 'P1', type: 'skeleton', x: 1, y: 1)
    target_field = Position.new(2, 2)
    test_game.move(skelly.position, target_field)
    assert_equal skelly, test_game.board.check_field(target_field).occupant
    assert_equal target_field, test_game.board.check_field(target_field).occupant.position
  end

  def test_a_minion_cannot_move_out_of_bounds
    # skip
    test_game = Game.new(3)
    test_game.add_player('P1', max_mana: 5,
                               summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    skelly = test_game.place(owner: 'P1', type: 'skeleton', x: 0, y: 0)
    assert_raises(InvalidPositionError) do
      test_game.board.move(skelly.position, Position.new(-1, -1))
    end
  end

  def test_skeletons_can_only_move_1_square_diagonally_and_2_straight
    # skip
    test_game = Game.new(4)
    test_game.add_player('P1', max_mana: 5,
                               summoning_zone: [[0, 0], [0, 1], [0, 2], [0, 3], [1, 0], [1, 1], [1, 2], [1, 3], [2, 0], [2, 1], [2, 2], [2, 3], [3, 0], [3, 1], [3, 2], [3, 3]])
    skelly = test_game.place(owner: 'P1', type: 'skeleton', x: 0, y: 0)
    target_field = Position.new(2, 2)
    assert_raises(InvalidMovementError) do
      test_game.move(skelly.position, target_field)
    end
    target_field = Position.new(0, 3)
    assert_raises(InvalidMovementError) do
      test_game.move(skelly.position, target_field)
    end
    target_field = Position.new(0, 2)
    test_game.move(skelly.position, target_field)
    target_field = Position.new(1, 1)
    test_game.move(skelly.position, target_field)
    assert_equal skelly, test_game.board.check_field(target_field).occupant
  end

  def test_skeleton_cant_step_on_another_skeleton_or_move_to_an_occupied_square
    # skip
    test_game = Game.new(3)
    test_game.add_player('P1', max_mana: 5,
                               summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    skelly = test_game.place(owner: 'P1', type: 'skeleton', x: 0, y: 0)
    skellys_estranged_cousin_timmy = test_game.place(owner: 'P1', type: 'skeleton', x: 0, y: 1)
    assert_raises(InvalidMovementError) do
      test_game.move(skelly.position, skellys_estranged_cousin_timmy.position)
    end
  end

  def test_skeleton_can_only_attack_another_players_minion
    test_game = Game.new(3)
    test_game.add_player('P1', max_mana: 5,
                               summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    test_game.add_player('P2')
    skelly = test_game.place(owner: 'P1', type: 'skeleton', x: 0, y: 0)
    skellys_sworn_enemy_kevin = test_game.place(owner: 'P1', type: 'skeleton', x: 0, y: 1)
    assert_raises(InvalidTargetError) do
      test_game.attack(skelly.position, skellys_sworn_enemy_kevin.position)
    end
  end

  def test_skeleton_can_attack_within_1_square
    # skip
    test_game = Game.new(3)
    test_game.add_player('P1', max_mana: 5,
                               summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    test_game.add_player('P2', max_mana: 5,
                               summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    skelly = test_game.place(owner: 'P1', type: 'skeleton', x: 0, y: 0)
    skellys_sworn_enemy_kevin = test_game.place(owner: 'P2', type: 'skeleton', x: 0, y: 1)
    test_game.attack(skelly.position, skellys_sworn_enemy_kevin.position)
    assert_equal 4, test_game.board.check_field(skellys_sworn_enemy_kevin.position).occupant.health
  end

  def test_skeleton_cannot_attack_from_further_than_their_range
    # skip
    test_game = Game.new(3)
    test_game.add_player('P1', max_mana: 5,
                               summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    test_game.add_player('P2', max_mana: 5,
                               summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    skelly = test_game.place(owner: 'P1', type: 'skeleton', x: 0, y: 0)
    skellys_sworn_enemy_kevin = test_game.place(owner: 'P2', type: 'skeleton', x: 0, y: 2)
    assert_raises(OutOfRangeError) do
      test_game.attack(skelly.position, skellys_sworn_enemy_kevin.position)
    end
  end

  def test_skeleton_cant_attack_an_empty_field
    # skip
    test_game = Game.new(3)
    test_game.add_player('P1', max_mana: 5,
                               summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    skelly = test_game.place(owner: 'P1', type: 'skeleton', x: 0, y: 0)
    suspicious_patch_of_grass = Position.new(0, 1)
    assert_raises(InvalidTargetError) do
      test_game.attack(skelly.position, suspicious_patch_of_grass)
    end
  end

  def test_skeleton_cant_attack_an_out_of_bound_field
    # skip
    test_game = Game.new(3)
    test_game.add_player('P1', max_mana: 5,
                               summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    skelly = test_game.place(owner: 'P1', type: 'skeleton', x: 0, y: 0)
    assert_raises(InvalidPositionError) do
      test_game.attack(skelly.position, Position.new(0, -1))
    end
  end

  def test_minion_with_0_hp_perishes
    # skip
    test_game = Game.new(3)
    test_game.add_player('P1', max_mana: 5,
                               summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    test_game.add_player('P2', max_mana: 5,
                               summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    skelly = test_game.place(owner: 'P1', type: 'skeleton', x: 0, y: 0)
    skellys_sworn_enemy_kevin = test_game.place(owner: 'P2', type: 'skeleton', x: 0, y: 1)
    test_game.attack(skelly.position, skellys_sworn_enemy_kevin.position)
    test_game.attack(skelly.position, skellys_sworn_enemy_kevin.position)
    test_game.attack(skelly.position, skellys_sworn_enemy_kevin.position)
    test_game.attack(skelly.position, skellys_sworn_enemy_kevin.position)
    test_game.attack(skelly.position, skellys_sworn_enemy_kevin.position)
    assert_equal false, test_game.board.check_field(skellys_sworn_enemy_kevin.position).is_occupied?
  end

  def test_game_has_player_space
    test_game = Game.new(3)
    assert_equal [], test_game.players
  end

  def test_game_can_have_players_added
    test_game = Game.new(3)
    test_game.add_player('Mateusz')
    test_game.add_player('Michal')
    assert_equal 2, test_game.players.size
  end

  def test_game_cant_have_two_players_with_same_name
    test_game = Game.new(3)
    test_game.add_player('Mateusz')
    assert_raises(DuplicatePlayerError) do
      test_game.add_player('Mateusz')
    end
  end

  def test_all_players_in_game_are_instances_of_player_class
    test_game = Game.new(3)
    test_game.add_player('Mateusz')
    test_game.add_player('Michal')
    assert(test_game.players.all? { |player| player.instance_of?(Player) })
  end

  def test_players_can_have_manapools_when_added
    test_game = Game.new(3)
    test_game.add_player('Mateusz', max_mana: 5)
    test_game.add_player('Michal', max_mana: 5)
    assert(test_game.players.all? { |player| player.mana != 0 })
  end

  def test_players_outside_of_the_game_cant_summon_minions
    # skip
    test_game = Game.new(3)
    assert_raises(UnknownPlayerError) do
      test_game.place(owner: 'Mateusz', type: 'skeleton', x: 0, y: 0)
    end
  end

  def test_summoning_minions_costs_mana
    test_game = Game.new(3)
    test_player_name = 'Mateusz'
    test_game.add_player(test_player_name, max_mana: 5,
                                           summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    test_game.place(owner: test_player_name, type: 'skeleton', x: 0, y: 0)
    assert_equal 4, test_game.players.select { |player| player.name == test_player_name }.first.mana
  end

  def test_cant_summon_minions_with_insufficient_mana
    test_game = Game.new(3)
    test_player_name = 'Mateusz'
    test_game.add_player(test_player_name, max_mana: 0,
                                           summoning_zone: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]])
    assert_raises(InsufficientManaError) do
      test_game.place(owner: test_player_name, type: 'skeleton', x: 0, y: 0)
    end
  end

  def test_cant_summon_minions_outside_of_your_summoning_zone
    test_game = Game.new(3)
    test_player_name = 'Mateusz'
    test_game.add_player(test_player_name, max_mana: 5, summoning_zone: [[0, 0], [0, 1]])
    assert_raises(InvalidPositionError) do
      test_game.place(owner: test_player_name, type: 'skeleton', x: 2, y: 0)
    end
  end
end
