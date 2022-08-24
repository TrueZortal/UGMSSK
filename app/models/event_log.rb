class EventLog < ApplicationRecord
  def self.save_event(event, game_id: nil)
    db_event = EventLog.new(game_id: game_id, event: event)
    db_event.save
  end

  def self.place(unit_db_record, mana_after_placing)
    remaining_mana = "they have #{mana_after_placing} mana remaining."
    event = "#{unit_db_record.owner} placed #{unit_db_record.minion_type} on [#{unit_db_record.x_position},#{unit_db_record.y_position}] for #{MinionStat.find_by(minion_type: unit_db_record.minion_type).mana_cost} mana, #{remaining_mana}"
    save_event(event)
  end

  def self.move(unit_db_record, from_position, to_position)
    event = "#{unit_db_record.owner} moved #{unit_db_record.minion_type} from #{from_position} to #{to_position}"
    save_event(event)
  end

  # def self.attack(unit, another_unit, damage)
  #   message = another_unit.health.positive? ? "has #{another_unit.current_health} health" : 'perished'
  #   who_attacked_who = "#{unit.owner} attacked #{another_unit.owner}s #{another_unit.type} with their #{unit.type}"
  #   from_to_position = "from #{unit.position.to_a} to #{another_unit.position.to_a}"
  #   attacked_unit_status = "#{another_unit.owner}s #{another_unit.type} #{message}"
  #   event = " #{who_attacked_who} #{from_to_position} causing #{damage} damage. #{attacked_unit_status}"
  #   save_event(event)
  # end

  # def self.concede(player)
  #   minion_list = player.minions.map(&:status).join("\n")
  #   event = "#{player.name} has conceded, their minions #{minion_list} all perished"
  #   save_event(event)
  # end

end
