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
    else
      SummonedMinion.find(db_record.id).destroy
    end
  end

  def self.move(minion_record: nil, parameters: nil)
    p minion_record
    p parameters
  end
end
