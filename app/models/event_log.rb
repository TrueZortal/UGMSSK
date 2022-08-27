# frozen_string_literal: true

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

  def self.move(unit_db_record, from_field, to_field)
    from_position = [from_field.x_position, from_field.y_position].to_s
    to_position = [to_field.x_position, to_field.y_position].to_s
    event = "#{unit_db_record.owner} moved #{unit_db_record.minion_type} from #{from_position} to #{to_position}"
    save_event(event)
  end

  def self.attack(unit_db_record, another_unit_db_record, damage, health_after_damage)
    message = health_after_damage.positive? ? "has #{health_after_damage}/#{MinionStat.find_by(minion_type: another_unit_db_record.minion_type).health} health" : 'perished'
    from_position = [unit_db_record.x_position, unit_db_record.y_position].to_s
    to_position = [another_unit_db_record.x_position, another_unit_db_record.y_position].to_s
    who_attacked_who = "#{unit_db_record.owner} attacked #{another_unit_db_record.owner}s #{another_unit_db_record.minion_type} at #{to_position} with their #{unit_db_record.minion_type}"
    attacked_unit_status = "#{another_unit_db_record.owner}s #{another_unit_db_record.minion_type} #{message}"
    event = " #{who_attacked_who}causing #{damage} damage. #{attacked_unit_status}"
    save_event(event)
  end

  def self.got_abandoned(unit_db_record: nil)
    event = "#{unit_db_record.minion_type} on [#{unit_db_record.x_position},#{unit_db_record.y_position}] has perished abandoned by #{unit_db_record.owner}"
    save_event(event)
  end

  def self.has_lost(player_db_record: nil)
    event = "#{player_db_record.name} has lost all of their mana and minions, they've been eliminated"
    save_event(event)
  end

  def self.winner(player_db_record: nil)
    event = "#{player_db_record.name} has emerged victorious!!!"
    save_event(event)
  end

  def self.has_passed(player_db_record: player)
    event = "#{player_db_record.name} has passed their turn"
    save_event(event)
  end

  def self.has_conceded(player_db_record: player)
    event = "#{player_db_record.name} has conceded"
    save_event(event)
  end

  def self.error(error_msg)
    event = "#{error_msg} has occured"
    save_event(event)
  end
end
