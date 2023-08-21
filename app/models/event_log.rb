# frozen_string_literal: true

class EventLog < ApplicationRecord
  def self.place(unit_db_record, mana_after_placing)
    remaining_mana = "they have #{mana_after_placing} mana remaining."
    event = "#{unit_db_record.owner} placed #{unit_db_record.minion_type} on [#{unit_db_record.x_position},#{unit_db_record.y_position}] for #{SummonedMinionManager::FindMinionManaFromMinionRecord.call(unit_db_record)} mana, #{remaining_mana}"
    save_event(event, game_id: unit_db_record.game_id)
  end

  def self.move(unit_db_record, from_field, to_field)
    from_position = [from_field.x_position, from_field.y_position].to_s
    to_position = [to_field.x_position, to_field.y_position].to_s
    event = "#{unit_db_record.owner} moved #{unit_db_record.minion_type} from #{from_position} to #{to_position}"
    save_event(event, game_id: unit_db_record.game_id)
  end

  def self.attack(unit_db_record, another_unit_db_record, damage, health_after_damage)
    message = health_after_damage.positive? ? "has #{health_after_damage}/#{SummonedMinionManager::FindMinionHealthFromMinionRecord.call(another_unit_db_record)} health" : 'perished'
    from_position = [unit_db_record.x_position, unit_db_record.y_position].to_s
    to_position = [another_unit_db_record.x_position, another_unit_db_record.y_position].to_s
    who_attacked_who = "#{unit_db_record.owner} attacked #{another_unit_db_record.owner}s #{another_unit_db_record.minion_type} at #{to_position} with their #{unit_db_record.minion_type}"
    attacked_unit_status = "#{another_unit_db_record.owner}s #{another_unit_db_record.minion_type} #{message}"
    event = " #{who_attacked_who}causing #{damage} damage. #{attacked_unit_status}"
    save_event(event, game_id: unit_db_record.game_id)
  end

  def self.got_abandoned(unit_db_record: nil)
    event = "#{unit_db_record.minion_type} on [#{unit_db_record.x_position},#{unit_db_record.y_position}] has perished abandoned by #{unit_db_record.owner}"
    save_event(event, game_id: unit_db_record.game_id)
  end

  def self.has_lost(player_db_record: nil)
    event = "#{player_db_record.name} has lost all of their mana and minions, they've been eliminated"
    save_event(event, game_id: player_db_record.game_id)
  end

  def self.winner(player_db_record: nil)
    event = "#{player_db_record.name} has emerged victorious!!! Reset Board to restart!"
    save_event(event, game_id: player_db_record.game_id)
  end

  def self.has_passed(player_db_record: player)
    event = "#{player_db_record.name} has passed their turn"
    save_event(event, game_id: player_db_record.game_id)
  end

  def self.has_conceded(player_db_record: player)
    event = "#{player_db_record.name} has conceded"
    save_event(event, game_id: player_db_record.game_id)
  end

  def self.error(error_msg)
    event = "#{error_msg} has occured"
  end

  class << self
    private

    def save_event(event, game_id: nil)
      db_event = EventLog.new(game_id: game_id, event: event)
      db_event.save

      Turbo::StreamsChannel.broadcast_prepend_later_to(
        "game_field",
        target: "combatlog",
        partial: "games/combatlog_message",
        locals: {
          line: db_event
        }
      )
    end
  end
end
