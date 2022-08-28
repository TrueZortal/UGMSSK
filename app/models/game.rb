# frozen_string_literal: true

class Game < ApplicationRecord
  def self.add_player(game_id: nil, player_id: nil)
    game = Game.find(game_id)
    game.player_ids << player_id
    game.save
  end

  def self.set_current_player(game_id: nil, player_id: nil)
    game = Game.find(game_id)
    game.update(current_player_id: player_id)
    game.save
  end

  def self.remove_players_who_lost(game_id: nil)
    Game.find(game_id).player_ids.each do |player_id|
      next unless PvpPlayers.has_lost?(player_id: player_id)

      player = PvpPlayers.find(player_id)
      EventLog.has_lost(player_db_record: player)
      players = Game.find(game_id).player_ids - [player_id]
      Game.find(game_id).update(player_ids: players)
    end
  end

  def self.move_game_to_next_turn(game_id: nil)
    game = Game.find(game_id)
    turn = game.current_turn + 1
    game.update(current_turn: turn)
    game.save
  end

  def self.start_new(parameters: nil)
    game = Game.new(current_turn: 0)
    game.save
    2.times do
      PvpPlayers.add_player(game.id)
    end
    BoardState.create_board(game_id: game.id, size_of_board_edge: 8)
    PvpPlayers.check_and_set_available_player_actions(game_id: game.id)
    game
  end

  def self.continue(game_id: nil)
    Game.last
    # Game.find(game_id)
  end

  # takes: game_id
  # returns array of fields in range
  def self.check_and_update_minions_who_can_attack(game_id: nil)
    clear_targets_and_can_attack_clauses_for_all_minion_occupied_fields(game_id: game_id)
    occupied_fields = BoardField.where(game_id: game_id, occupied: true, obstacle: false)
    occupied_fields.each do |field|
      occupied_fields.each do |another_field|
        next unless validate_targets(field, another_field)

        minion = SummonedMinion.find(field.occupant_id)
        minion.update(can_attack: true)
        minion.available_targets << another_field.occupant_id
        minion.save
      end
    end
  end

  def self.validate_targets(field, another_field)
    p ' THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS'
    p ' THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS'
    p ' THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS'
    p ' THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS'
    p "condition met, not self harming #{field.occupant_id != another_field.occupant_id}"
    p "condition met, not team killing #{SummonedMinion.find(field.occupant_id).owner_id != SummonedMinion.find(another_field.occupant_id).owner_id}"
    p "condition met, in range #{Calculations.distance(field,
                                                       another_field) < MinionStat.find_by(minion_type: field.occupant_type).range}"
    p "condition met, line of sight exists #{check_if_line_exists_between_two_fields(field, another_field)}"
    p "overall #{ field.occupant_id != another_field.occupant_id && SummonedMinion.find(field.occupant_id).owner_id != SummonedMinion.find(another_field.occupant_id).owner_id && Calculations.distance(
      field, another_field
    ) < MinionStat.find_by(minion_type: field.occupant_type).range && check_if_line_exists_between_two_fields(field,
                                                                                                              another_field)}"
    p ' THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS'
    p ' THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS'
    p ' THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS'
    p ' THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS THIS'

    field.occupant_id != another_field.occupant_id && SummonedMinion.find(field.occupant_id).owner_id != SummonedMinion.find(another_field.occupant_id).owner_id && Calculations.distance(
      field, another_field
    ) < MinionStat.find_by(minion_type: field.occupant_type).range && check_if_line_exists_between_two_fields(field,
                                                                                                              another_field)
  end

  def self.clear_targets_and_can_attack_clauses_for_all_minion_occupied_fields(game_id: nil)
    BoardField.where(game_id: game_id, occupied: true, obstacle: false).each do |field|
      reset_minion = SummonedMinion.find(field.occupant_id)
      reset_minion.update(
        can_attack: false,
        available_targets: []
      )
      reset_minion.save
    end
  end

  def self.check_if_line_exists_between_two_fields(field, another_field)
    routes = []
    routes << get_route_between(field, another_field)
    routes << get_route_between(another_field, field)
    the_answer = []
    routes.each do |route|
      test_array = []
      route.each do |coordinate|
        test_array << BoardField.find_by(x_position: coordinate[0], y_position: coordinate[1]).obstacle
      end
      the_answer << test_array.any?(true)
    end
    the_answer.any?(false)
  end

  def self.get_route_between(field, another_field)
    relative_position = relative_distance_between_two_fields(field, another_field)
    coordinates_between = []
    temp_position = [another_field.x_position, another_field.y_position]
    until relative_position == [0, 0]
      change_of_x = decide_modifier(relative_position[0])
      change_of_y = decide_modifier(relative_position[1])
      temp_position = [temp_position[0] + change_of_x, temp_position[1] + change_of_y]
      coordinates_between << temp_position
      relative_position = relative_distance_between_two_fields(field,
                                                               BoardField.find_by(x_position: temp_position[0],
                                                                                  y_position: temp_position[1]))
    end
    coordinates_between - [field.x_position, field.y_position]
  end

  def self.decide_modifier(value)
    if value.negative?
      -1
    elsif value.positive?
      1
    else
      0
    end
  end

  def self.relative_distance_between_two_fields(field, another_field)
    [field.x_position - another_field.x_position, field.y_position - another_field.y_position]
  end
end
