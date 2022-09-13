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
  def self.attack(parameters: nil)
    minion = SummonedMinion.find parameters['id']
    target = SummonedMinion.find parameters['target_id']
    attack_field = BoardField.find_by(occupant_id: target.id)
    owner = PvpPlayers.find(minion.owner_id)
    begin
      raise WrongPlayerError if minion.owner_id != TurnTracker.pull_current_player_id(game_id: owner.game_id).id
      raise InvalidTargetError unless minion.available_targets.include?(target.id)

      damage = MinionStat.find_by(minion_type: minion.minion_type).attack - MinionStat.find_by(minion_type: target.minion_type).defense
      damage = 1 if damage.negative?

      health_after_damage = target.health - damage
      if health_after_damage <= 0
        EventLog.attack(minion, target, damage, health_after_damage)
        SummonedMinion.delete(target.id)
        attack_field.update(
          occupant_id: nil,
          occupant_type: '',
          occupied: false
        )
      else
        target.update(health: health_after_damage)
        EventLog.attack(minion, target, damage, health_after_damage)
      end
      TurnTracker.end_turn(game_id: owner.game_id, player_id: minion.owner_id)
    rescue StandardError => e
      EventLog.error(e)
    end
  end

  def self.place(parameters: nil)
    minion_params = parameters['summoned_minion']
    minion_type = minion_params['minion_type']
    minion_to_summon = SummonedMinion.new(
      owner: minion_params['owner'],
      owner_id: minion_params['owner_id'],
      game_id: minion_params['game_id'],
      minion_type: minion_params['minion_type'],
      health: MinionStat.find_by(minion_type: minion_type).health,
      x_position: minion_params['x_position'],
      y_position: minion_params['y_position']
    )
    minion_to_summon.save
    owner = PvpPlayers.find(minion_to_summon.owner_id)
    mana_before = owner.mana
    mana_after = mana_before - MinionStat.find_by(minion_type: minion_to_summon.minion_type).mana_cost
    target_field_record = BoardField.find_by(game_id: owner.game_id, x_position: minion_to_summon.x_position,
                                             y_position: minion_to_summon.y_position)

    begin
      raise InvalidPlacementError if target_field_record.occupied
      raise InsufficientManaError if mana_after.negative?

      if !target_field_record.occupied && !mana_after.negative?
        owner.update(mana: mana_after)
        EventLog.place(minion_to_summon, mana_after)
        target_field_record.update(
          occupant_id: minion_to_summon.id,
          occupant_type: minion_to_summon.minion_type,
          occupied: true
        )
        TurnTracker.end_turn(game_id: owner.game_id, player_id: minion_to_summon.owner_id)
      end
    rescue StandardError => e
      EventLog.error(e)
      SummonedMinion.find(minion_to_summon.id).destroy
    end
  end

  def self.move(parameters: nil)
    minion_params = parameters['summoned_minion']
    minion = SummonedMinion.find parameters['id']
    owner = PvpPlayers.find(minion.owner_id)
    game_id = owner.game_id

    raise WrongPlayerError if minion.owner_id != TurnTracker.pull_current_player_id(game_id: game_id).id

    speed = MinionStat.find_by(minion_type: minion.minion_type).speed
    from_field = BoardField.find_by(game_id: game_id, x_position: minion.x_position, y_position: minion.y_position)
    to_field = BoardField.find_by(game_id: game_id, x_position: minion_params['x_position'].to_i,
                                  y_position: minion_params['y_position'].to_i)
    shortest_path = Pathfinding.find_shortest_path(from_field, to_field, game_id: game_id)
    raise InvalidMovementError if !minion.valid_moves.include?(to_field.id)

    if shortest_path <= speed
      from_field.update(
        occupant_id: nil,
        occupant_type: '',
        occupied: false
      )
      to_field.update(
        occupant_id: minion.id,
        occupant_type: minion.minion_type,
        occupied: true
      )
      EventLog.move(minion, from_field, to_field)

      minion.update(
        x_position: minion_params['x_position'],
        y_position: minion_params['y_position']
      )
      TurnTracker.end_turn(game_id: game_id, player_id: minion.owner_id)
    end
  end

  def self.get_abandoned(minion_id: nil)
    EventLog.got_abandoned(unit_db_record: SummonedMinion.find(minion_id))
    BoardField.find_by(occupant_id: minion_id).update(
      occupant_id: nil,
      occupant_type: '',
      occupied: false
    )
    SummonedMinion.find(minion_id).delete
  end
end
