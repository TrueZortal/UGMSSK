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
      # Need to add find fields with enemies in range for attacking logic


    end
    rescue StandardError
      SummonedMinion.find(db_record.id).destroy
    end
  end


  #<SummonedMinion id: 16, owner_id: 29, owner: "Player1", minion_type: "skeleton archer", health: 2, x_position: 2, y_position: 3, created_at: "2022-08-24 21:24:46.169036000 +0000", updated_at: "2022-08-24 21:26:08.392501000 +0000", can_attack: false>
  #<ActionController::Parameters {"owner_id"=>"29", "x_position"=>"3", "y_position"=>"3"} permitted: false>
  def self.move(db_record: nil, parameters: nil)
    owner = PvpPlayers.find(db_record.owner_id)
    speed = MinionStat.find_by(minion_type: db_record.minion_type).speed
    from_field = BoardField.find_by(game_id: owner.game_id, x_position: db_record.x_position, y_position: db_record.y_position)
    to_field = BoardField.find_by(game_id: owner.game_id, x_position: parameters['x_position'].to_i, y_position: parameters['y_position'].to_i)
    shortest_path = Pathfinding.find_shortest_path(from_field, to_field, game_id: owner.game_id)

    raise InvalidMovementError if shortest_path > MinionStat.find_by(minion_type: db_record.minion_type).speed

    if shortest_path <= speed
      from_field.update(
        occupant_id: nil,
        occupant_type: '',
        occupied: false
      )
      to_field.update(
        occupant_id: db_record.id,
        occupant_type: db_record.minion_type,
        occupied: true
      )
      EventLog.move(db_record, from_field, to_field)
      TurnTracker.end_turn(game_id: owner.game_id, player_id: db_record.owner_id)

      # Need to add find fields with enemies in range for attacking logic
    end
  end
end

# @board_fields&.filter do |field|
#   field.position != @position && @position.distance(field.position) <= @range
# end&.each do |field|
#   @fields_in_attack_range << field
# end
# @fields_in_attack_range.uniq!


# fields_in_attack_range = []
# BoardField.where(game_id: owner.game_id).each do |field|
#   distance = Calculations.distance(starting_field, field)
#   if distance < range && field.occupied && !field.obstacle && starting_field.id != field.id
#     p starting_field.id
#     p field.id
#     p starting_field.id != field.id
#     fields_in_attack_range << field
#   end
# end
# fields_in_attack_range