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

  def self.move_game_to_next_turn(game_id: nil)
    game = Game.find(game_id)
    turn = game.current_turn + 1
    game.update(current_turn: turn)
    game.save
  end

  #takes: game_id
  #returns array of fields in range
  def self.check_and_update_minions_who_can_attack(game_id: nil)
    clear_targets_and_can_attack_clauses_for_all_minion_occupied_fields(game_id: game_id)
    occupied_fields = BoardField.where(game_id: game_id, occupied: true, obstacle: false)
    occupied_fields.each do |field|
      occupied_fields.each do |another_field|
        if validate_targets(field, another_field)
          # p "THIS HAS HAPPENED"
          minion = SummonedMinion.find(field.occupant_id)
          minion.update(can_attack: true)
          minion.available_targets << another_field.occupant_id
          minion.save
        end
      end
    end
  end

  def self.validate_targets(field, another_field)
    field.occupant_id != another_field.occupant_id && SummonedMinion.find(field.occupant_id).owner_id != SummonedMinion.find(another_field.occupant_id).owner_id && Calculations.distance(field, another_field) < MinionStat.find_by(minion_type: field.occupant_type).range
  end

  def self.clear_targets_and_can_attack_clauses_for_all_minion_occupied_fields(game_id: nil)
    BoardField.where(game_id: game_id, occupied: true, obstacle: false).each do |field|
      # p "THIS OTHER THING HAS HAPPENED (RESETTING)"
      reset_minion = SummonedMinion.find(field.occupant_id)
      reset_minion.update(
      can_attack: false,
      available_targets: []
      )
      reset_minion.save
    end
  end
end
