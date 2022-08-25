#implement below errors:
# class InvalidMovementError < StandardError
# end

# class OutOfRangeError < StandardError
# end

# class InvalidTargetError < StandardError
# end

class InsufficientManaError < StandardError
end

class InvalidPlacementError < StandardError
end

class InvalidMovementError < StandardError
end

class SummonedMinion < ApplicationRecord

  #<ActionController::Parameters {"authenticity_token"=>"_TWhDYYJ3_K1rFu4RJcILakDJynGWV0QXoymLpzklG-0vZ0PYoEgB9gOhzC-v9XK9bxN6TFXs6YGx57x5kmIyg", "minion_type"=>"skeleton archer", "target_id"=>"38", "minion_target"=>"skeleton", "commit"=>"submit", "controller"=>"summoned_minions", "action"=>"update_attack", "id"=>"39"} permitted: false>
  def self.attack(parameters:nil)
    minion = SummonedMinion.find parameters['id']
    target = SummonedMinion.find parameters['target_id']
    owner = PvpPlayers.find(minion.owner_id)
    damage = MinionStat.find_by(minion_type:minion.minion_type).attack - MinionStat.find_by(minion_type: target.minion_type).defense
      if damage.negative?
        damage = 1
      end
    health_after_damage = target.health - damage
    target.update(health: health_after_damage)
    TurnTracker.end_turn(game_id: owner.game_id, player_id: minion.owner_id)
  end

  def self.place(db_record: '')
    owner = PvpPlayers.find(db_record.owner_id)
    mana_before = owner.mana
    mana_after = mana_before - MinionStat.find_by(minion_type: db_record.minion_type).mana_cost
    target_field_record = BoardField.find_by(game_id: owner.game_id, x_position: db_record.x_position, y_position: db_record.y_position)

    begin
    raise InvalidPlacementError if target_field_record.occupied
    raise InsufficientManaError if mana_after.negative?

    if !target_field_record.occupied && !mana_after.negative?
      owner.update(mana: mana_after)
      EventLog.place(db_record, mana_after)
      target_field_record.update(
        occupant_id: db_record.id,
        occupant_type: db_record.minion_type,
        occupied: true
      )
      TurnTracker.end_turn(game_id: owner.game_id, player_id: db_record.owner_id)
    end
    rescue StandardError
      SummonedMinion.find(db_record.id).destroy
    end
  end


  #<SummonedMinion id: 16, owner_id: 29, owner: "Player1", minion_type: "skeleton archer", health: 2, x_position: 2, y_position: 3, created_at: "2022-08-24 21:24:46.169036000 +0000", updated_at: "2022-08-24 21:26:08.392501000 +0000", can_attack: false>
  #<ActionController::Parameters {"owner_id"=>"29", "x_position"=>"3", "y_position"=>"3"} permitted: false>
  def self.move(parameters: nil)
    minion_params = parameters['summoned_minion']
    minion = SummonedMinion.find parameters['id']
    owner = PvpPlayers.find(minion.owner_id)
    game_id = owner.game_id
    speed = MinionStat.find_by(minion_type: minion.minion_type).speed
    from_field = BoardField.find_by(game_id: game_id, x_position: minion.x_position, y_position: minion.y_position)
    to_field = BoardField.find_by(game_id: game_id, x_position: minion_params['x_position'].to_i, y_position: minion_params['y_position'].to_i)
    shortest_path = Pathfinding.find_shortest_path(from_field, to_field, game_id: game_id)

    p shortest_path
    p MinionStat.find_by(minion_type: minion.minion_type).speed
    raise InvalidMovementError if shortest_path > MinionStat.find_by(minion_type: minion.minion_type).speed

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

end
