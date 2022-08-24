class SummonedMinion < ApplicationRecord
  def self.place(db_record: '')
    owner = PvpPlayers.find(db_record.owner_id)
    mana_before = owner.mana
    mana_after = mana_before - MinionStat.find_by(minion_type: db_record.minion_type).mana_cost


    owner.update(mana: mana_after)
    EventLog.place(db_record, mana_after)
    BoardField.find_by(game_id: owner.game_id, x_position: db_record.x_position, y_position: db_record.y_position).update(
      occupant_id: db_record.id,
      occupant_type: db_record.minion_type,
      occupied: true
    )
    TurnTracker.end_turn(game_id: owner.game_id, player_id: db_record.owner_id)
  end
end
