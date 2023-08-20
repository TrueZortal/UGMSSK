# frozen_string_literal: true

class InvalidTargetError < StandardError
end

class InsufficientManaError < StandardError
end

class InvalidPlacementError < StandardError
end

class InvalidMovementError < StandardError
end

class WrongPlayerError < StandardError
end

class SummonedMinion < ApplicationRecord
  def self.update_drag(from_field = nil, to_field = nil)
    if to_field.occupied && !to_field.obstacle
      pseudo_params = {
        'id' => from_field.occupant_id,
        'target_id' => to_field.occupant_id
      }
      attack(parameters: pseudo_params)
    else
      pseudo_params = {
        'id' => from_field.occupant_id,
        'summoned_minion' => {
          'x_position' => to_field.x_position,
          'y_position' => to_field.y_position
        }
      }
      move(parameters: pseudo_params)
    end
  end

  # TODO: Make checking the field occupancy the first check
  def self.place(parameters: nil)
    minion_params = parameters['summoned_minion']
    minion_position = SummonedMinionManager::TransformPositionIntoXYHash.call(minion_params['position'])
    minion_type = minion_params['minion_type']
    summoned_minion_stats = MinionStat.find_by(minion_type: minion_type)
    minion_to_summon = SummonedMinion.new(
      owner: minion_params['owner'],
      owner_id: minion_params['owner_id'],
      game_id: minion_params['game_id'],
      minion_type: minion_params['minion_type'],
      health: summoned_minion_stats.health,
      x_position: minion_position[:x_position],
      y_position: minion_position[:y_position]
    )
    minion_to_summon.save
    owner = PvpPlayers.find(minion_to_summon.owner_id)
    mana_before = owner.mana
    mana_after = mana_before - summoned_minion_stats.mana_cost
    target_field_record = BoardField.find_by(game_id: owner.game_id, x_position: minion_to_summon.x_position,
                                             y_position: minion_to_summon.y_position)

    begin
      raise InvalidPlacementError if target_field_record.occupied
      raise InsufficientManaError if mana_after.negative?

      if !target_field_record.occupied && !mana_after.negative?
        owner.update(mana: mana_after)
        EventLog.place(minion_to_summon, mana_after)
        BoardFieldManager::UpdateFieldOccupant.call(target_field_record, minion_to_summon)
        TurnTracker.end_turn(game_id: owner.game_id, player_id: minion_to_summon.owner_id)
      end
    rescue StandardError => e
      EventLog.error(e)
      SummonedMinion.find(minion_to_summon.id).destroy
    end
  end

  def self.get_abandoned(minion_id: nil)
    minion = SummonedMinion.find(minion_id)
    BoardFieldManager::ClearFieldByOccupant.call(minion)
    EventLog.got_abandoned(unit_db_record: minion)
    minion.delete
  end

  def self.attack(parameters: nil)
    minion = SummonedMinion.find parameters['id']
    target = SummonedMinion.find parameters['target_id']
    owner = PvpPlayers.find(minion.owner_id)
    begin
      raise WrongPlayerError if minion.owner_id != Game.find(owner.game_id).current_player_id
      raise InvalidTargetError unless minion.available_targets.include?(target.id)

      damage = SummonedMinionManager::CalculateDamage.call(minion, target)

      health_after_damage = target.health - damage
      if health_after_damage <= 0
        BoardFieldManager::ClearFieldByOccupant.call(target)
        SummonedMinion.delete(target.id)
      else
        target.update(health: health_after_damage)
      end
      EventLog.attack(minion, target, damage, health_after_damage)
      TurnTracker.end_turn(game_id: owner.game_id, player_id: minion.owner_id)
    rescue StandardError => e
      EventLog.error(e)
    end
  end

  def self.move(parameters: nil)
    minion_params = parameters['summoned_minion']
    minion = SummonedMinion.find parameters['id']
    owner = PvpPlayers.find(minion.owner_id)
    game_id = owner.game_id

    raise WrongPlayerError if minion.owner_id != Game.find(owner.game_id).current_player_id

    from_field = BoardField.find_by(game_id: game_id, x_position: minion.x_position, y_position: minion.y_position)
    to_field = BoardField.find_by(game_id: game_id, x_position: minion_params['x_position'].to_i,
                                  y_position: minion_params['y_position'].to_i)
    raise InvalidMovementError unless minion.valid_moves.include?(to_field.id)

    if minion.valid_moves.include?(to_field.id)
      BoardFieldManager::ClearFieldByOccupant.call(minion)
      BoardFieldManager::UpdateFieldOccupant.call(to_field, minion)
      EventLog.move(minion, from_field, to_field)
      SummonedMinionManager::UpdateMinionsPositionFromTargetField.call(minion, to_field)
      TurnTracker.end_turn(game_id: game_id, player_id: minion.owner_id)
    end
  end
end
