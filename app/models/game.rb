# frozen_string_literal: true

class Game < ApplicationRecord
  def self.add_player(game_id: nil, player_id: nil)
    game = Game.find(game_id)
    GameManager::AddPlayer.call(game_id, player_id)
    SummoningZoneManager::AssignAvailableSummoningZoneFromAGameToAPlayer.call(game_id, player_id)
  end

  def self.remove_player(game_id: nil, player_id: nil)
    player = PvpPlayers.find(player_id)
    GameManager::RemovePlayer.call(game_id, player_id)
    SummoningZoneManager::ReturnSummoningZoneWhenLeavingOrRemoved.call(game_id, player_id)
    SummonedMinionManager::FindMinionsByOwner.call(player_id).each do |minion|
      SummonedMinion.get_abandoned(minion_id: minion.id)
    end
    TurnTracker.where(player_id: player_id).destroy_all
    JanitorManager::RemoveGameFromUser.call(player.uuid)
    player.destroy
  end

  def self.start_game(game_id: nil)
    game = Game.find(game_id)
    check_and_set_available_player_actions(game_record: game)
    game.update(
      underway: true
    )
    game.save
  end

  def self.end_turn(game_id: nil)
    game = Game.find(game_id)
    remove_players_who_lost(game_record: game)
    check_and_update_minions(game_id: game_id)
    check_win_conditions(game_record: game)
    check_and_set_available_player_actions(game_record: game)
  end

  class << self
    private

    def check_and_set_available_player_actions(game_record: nil)
      game_record.player_ids.each do |player_id|
        if there_are_minions_who_can_attack_and_there_is_mana(player_id)
          PvpPlayers.find(player_id).update(available_actions: %w[summon])
        elsif there_are_minions_who_can_attack_and_there_isnt_mana(player_id)
          PvpPlayers.find(player_id).update(available_actions: [])
        elsif there_are_minions_and_there_is_mana(player_id)
          PvpPlayers.find(player_id).update(available_actions: %w[summon])
        elsif there_are_minions_but_there_isnt_mana(player_id)
          PvpPlayers.find(player_id).update(available_actions: [])
        elsif there_are_no_minions_but_there_is_mana(player_id)
          PvpPlayers.find(player_id).update(available_actions: %w[summon])
        end
      end
    end

    def there_are_minions_who_can_attack_and_there_is_mana(player_id)
      !minions?(player_id: player_id) && minions_who_can_attack?(player_id: player_id) && mana?(player_id: player_id)
    end

    def there_are_minions_who_can_attack_and_there_isnt_mana(player_id)
      !minions?(player_id: player_id) && minions_who_can_attack?(player_id: player_id) && !mana?(player_id: player_id)
    end

    def there_are_minions_and_there_is_mana(player_id)
      !minions?(player_id: player_id) && mana?(player_id: player_id)
    end

    def there_are_minions_but_there_isnt_mana(player_id)
      !minions?(player_id: player_id) && !mana?(player_id: player_id)
    end

    def there_are_no_minions_but_there_is_mana(player_id)
      minions?(player_id: player_id) && mana?(player_id: player_id)
    end

    def minions?(player_id: nil)
      SummonedMinionManager::FindMinionsByOwner.call(player_id).empty?
    end

    def minions_who_can_attack?(player_id: nil)
      !SummonedMinion.where('owner_id = ? and can_attack = ?', player_id, true).empty?
    end

    def mana?(player_id: nil)
      PvpPlayers.find(player_id).mana.positive?
    end

    def player_has_lost?(player_id: nil)
      !mana?(player_id: player_id) && minions?(player_id: player_id)
    end

    def check_win_conditions(game_record: nil)
      players = game_record.player_ids
      EventLog.winner(player_db_record: PvpPlayers.find(players[0])) if players.size == 1
      game_record.update(underway: false) if game_record.current_turn != 0 && players.size == 1
      game_record.save
    end

    def remove_players_who_lost(game_record: nil)
      game_record.player_ids.each do |player_id|
        next unless player_has_lost?(player_id: player_id)

        player = PvpPlayers.find(player_id)
        EventLog.has_lost(player_db_record: player)
        GameManager::RemovePlayer.call(game_record.id, player_id)
      end
    end

    def check_and_update_minions(game_id: nil)
      clear_targets_and_can_attack_clauses_for_all_minion_occupied_fields(game_id: game_id)
      occupied_fields = BoardField.where(game_id: game_id, occupied: true, obstacle: false)
      pathfinding_data = JSON.parse(BoardState.find_by(game_id: game_id).pathfinding_data, { symbolize_nammes: true })
      occupied_fields.each do |field|
        minion_stats = SummonedMinionManager::FindMinionStatsFromMinionID.call(field.occupant_id)
        populate_possible_moves(game_id: game_id, field: field, minion_stats: minion_stats,
                                pathfinding_data: pathfinding_data)
        occupied_fields.each do |another_field|
          next unless another_field.occupied && validate_targets(field, another_field, minion_stats)

          minion = SummonedMinion.find(field.occupant_id)
          minion.update(can_attack: true)
          minion.available_targets << another_field.occupant_id
          minion.save
        end
      end
    end

    def populate_possible_moves(game_id: nil, field: nil, minion_stats: nil, pathfinding_data: nil)
      minion = SummonedMinion.find(field.occupant_id)
      valid_moves = []
      BoardField.where(game_id: game_id).each do |inner_field|
        next unless Calculations.distance(field, inner_field) <= minion_stats.speed

        shortest_path = Pathfinding.find_shortest_path(field, inner_field, game_id: game_id,
                                                                           pathfinding_data: pathfinding_data)
        if shortest_path <= minion_stats.speed && !inner_field.obstacle && !inner_field.occupied
          valid_moves << inner_field.id
        end
      end
      minion.update(valid_moves: valid_moves)
      minion.save
    end

    def validate_targets(field, another_field, minion_stats)
      Calculations.distance(field,
                            another_field) <= minion_stats.range && field.occupant_id != another_field.occupant_id && SummonedMinion.find(field.occupant_id).owner_id != SummonedMinion.find(another_field.occupant_id).owner_id && check_if_line_of_sight_exists_between_two_fields(
                              field, another_field
                            )
    end

    def clear_targets_and_can_attack_clauses_for_all_minion_occupied_fields(game_id: nil)
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

    def check_if_line_of_sight_exists_between_two_fields(field, another_field)
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

    def get_route_between(field, another_field)
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

    def decide_modifier(value)
      if value.negative?
        -1
      elsif value.positive?
        1
      else
        0
      end
    end

    def relative_distance_between_two_fields(field, another_field)
      [field.x_position - another_field.x_position, field.y_position - another_field.y_position]
    end
  end
end
