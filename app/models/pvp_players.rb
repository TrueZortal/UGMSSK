# frozen_string_literal: true

class PvpPlayers < ApplicationRecord
  # validates :board, presence: true
  def self.add_player(game_id)
    # if PvpPlayers.where(game_id: game_id).size < 4
    added_player = PvpPlayers.new(name: "Player#{PvpPlayers.all.size + 1}", mana: 10, max_mana: 10,
                                  summoning_zone: '', game_id: game_id)
    added_player.save
    Game.add_player(game_id: game_id, player_id: added_player.id)
    # end
  end

  def self.remove_player(game_id)
    PvpPlayers.where(game_id: game_id).last.destroy if PvpPlayers.where(game_id: game_id).size > 2
  end

  def self.pass(player_id: nil)
    TurnTracker.end_turn(game_id: PvpPlayers.find(player_id).game_id, player_id: player_id)
  end

  def self.concede(player_id: nil, game_id: nil)
    SummonedMinion.where(owner_id: player_id).each do |minion|
      SummonedMinion.get_abandoned(minion_id: minion)
    end
    EventLog.has_conceded(player_db_record: player)
    players = Game.find(game_id).player_ids - [player_id]
    Game.find(game_id).update(player_ids: players)
    TurnTracker.end_turn(game_id: PvpPlayers.find(player_id).game_id, player_id: player_id)
  end

  def self.check_and_set_available_player_actions(game_id: nil)
    Game.find(game_id).player_ids.each do |player_id|
        # there are minions who can attack and there is mana
      if !minions?(player_id: player_id) && minions_who_can_attack?(player_id: player_id) && mana?(player_id: player_id)
        PvpPlayers.find(player_id).update(available_actions: ['summon', 'move', 'attack', 'concede', 'pass'])
        # there are minions who can attack and there isn't mana
      elsif !minions?(player_id: player_id) && minions_who_can_attack?(player_id: player_id) && !mana?(player_id: player_id)
        PvpPlayers.find(player_id).update(available_actions: ['move', 'attack', 'concede', 'pass'])
        # there are minions and there is mana
      elsif !minions?(player_id: player_id) && mana?(player_id: player_id)
        PvpPlayers.find(player_id).update(available_actions: ['summon', 'move', 'concede', 'pass'])
        # there are minions but there isn't mana
      elsif !minions?(player_id: player_id) && !mana?(player_id: player_id)
        PvpPlayers.find(player_id).update(available_actions: ['move', 'concede', 'pass'])
      # there are no minions but there is mana
      elsif minions?(player_id: player_id) && mana?(player_id: player_id)
        PvpPlayers.find(player_id).update(available_actions: ['summon', 'concede', 'pass'])
      # there are no minions and there isnt mana
      elsif minions?(player_id: player_id) && !mana?(player_id: player_id)
        PvpPlayers.find(player_id).update(available_actions: ['concede', 'pass'])
      end
    end
  end

  def self.minions?(player_id: nil)
    SummonedMinion.where('owner_id = ?', player_id).empty?
  end

  def self.minions_who_can_attack?(player_id: nil)
    !SummonedMinion.where('owner_id = ? and can_attack = ?', player_id, true).empty?
  end

  def self.mana?(player_id: nil)
    PvpPlayers.find(player_id).mana.positive?
  end

  def self.has_lost?(player_id: nil)
    !mana?(player_id: player_id) && minions?(player_id: player_id)
  end
end


