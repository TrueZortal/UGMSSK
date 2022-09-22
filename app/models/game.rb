# frozen_string_literal: true

class Game < ApplicationRecord
  attr_reader :record_id

  def initialize(attributes = nil, &block)
    @record_id =  attributes.delete(:game_id) if attributes
    @game = Game.find(@record_id)

    super
  end

  def self.add_player(game_id: nil, player_id: nil)
    game = Game.find(game_id)
    game.player_ids << player_id
    game.save
    PvpPlayers.check_and_set_available_player_actions(game_id: game_id)
  end

  def exists_and_is_underway
    @game.underway
  end

  def exists_but_is_waiting_to_start_or_to_finish
    !PvpPlayers.where(game_id: @id).empty? || @game.current_turn == 0 && @game.underway
  end

  def self.start_game(game_id: nil)
    Game.find(game_id).update(
      underway: true
    )
  end

  def wait_for_start_or_to_finish
    @game
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

  def self.restart_new_on_existing_id(game_id: nil)
    game = Game.find(game_id)
    game.update(
      player_ids: [],
      current_turn: 0,
      current_player_id: nil,
      underway: false
    )
    game.save
    BoardState.create_board(game_id: game.id, size_of_board_edge: 8)
    PvpPlayers.check_and_set_available_player_actions(game_id: game_id)
    game
  end

  def continue
    @game
  end

  # takes: game_id
  # returns array of fields in range
  def self.check_and_update_minions_who_can_attack(game_id: nil)
    clear_targets_and_can_attack_clauses_for_all_minion_occupied_fields(game_id: game_id)
    occupied_fields = BoardField.where(game_id: game_id, occupied: true, obstacle: false)
    occupied_fields.each do |field|
      populate_possible_moves(game_id: game_id, field: field)
      occupied_fields.each do |another_field|


        if validate_targets(field, another_field)
          minion = SummonedMinion.find(field.occupant_id)
          minion.update(can_attack: true)
          minion.available_targets << another_field.occupant_id
          minion.save
        end
      end
    end
  end

  def self.populate_possible_moves(game_id: nil, field: nil)
    BoardField.where(game_id: game_id).each do |inner_field|
      shortest_path = Pathfinding.find_shortest_path_for_movement_array(field, inner_field, game_id: game_id)
      minion = SummonedMinion.find(field.occupant_id)
      if shortest_path <= MinionStat.find_by(minion_type: minion.minion_type).speed && !inner_field.obstacle && !inner_field.occupied #&& check_if_line_of_movement_exists_between_two_fields(field,inner_field)
        minion.valid_moves << inner_field.id
        minion.save
      end
    end
  end

  def self.validate_targets(field, another_field)
    field.occupant_id != another_field.occupant_id && SummonedMinion.find(field.occupant_id).owner_id != SummonedMinion.find(another_field.occupant_id).owner_id && Calculations.distance(
      field, another_field
    ) <= MinionStat.find_by(minion_type: field.occupant_type).range && check_if_line_of_sight_exists_between_two_fields(field,
                                                                                                              another_field)
  end

  def self.clear_targets_and_can_attack_clauses_for_all_minion_occupied_fields(game_id: nil)
    BoardField.where(game_id: game_id, occupied: true, obstacle: false).each do |field|
      reset_minion = SummonedMinion.find(field.occupant_id)
      reset_minion.update(
        can_attack: false,
        valid_moves: [],
        available_targets: []
      )
      reset_minion.save
    end
  end

  def self.check_if_line_of_sight_exists_between_two_fields(field, another_field)
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

  def self.check_if_line_of_movement_exists_between_two_fields(field, another_field)
    routes = []
    routes << get_route_between(field, another_field)
    routes << get_route_between(another_field, field)
    the_answer = []
    routes.each do |route|
      test_array = []
      route.each do |coordinate|
        test_array << (BoardField.find_by(x_position: coordinate[0], y_position: coordinate[1]).obstacle || BoardField.find_by(x_position: coordinate[0], y_position: coordinate[1]).occupied)
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
