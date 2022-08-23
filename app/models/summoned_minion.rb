class SummonedMinion < ApplicationRecord
  def self.place(db_record: '')
    mana_before = PvpPlayers.find(db_record.owner_id).mana
    mana_after = mana_before - MinionStat.find_by(minion_type: db_record.minion_type).mana_cost
    PvpPlayers.find(db_record.owner_id).update(mana: mana_after)
    EventLog.place(db_record, mana_after)
    # need to rewrite the board logic for fields to be stored within database
  end
end
