# frozen_string_literal: true

class PvpPlayers < ApplicationRecord
  def self.leave(player_id: nil)
    game_id = GameManager::FindGameIdByPlayerId.call(player_id)
    Game.remove_player(game_id: game_id, player_id: player_id)
  end

  def self.pass(player_id: nil)
    player = PvpPlayers.find(player_id)
    EventLog.has_passed(player_db_record: player)
    TurnTracker.end_turn(game_id: player.game_id, player_id: player_id)
  end

  def self.concede(player_id: nil)
    player = PvpPlayers.find(player_id)
    game_id = player.game_id
    EventLog.has_conceded(player_db_record: player)
    leave(player_id: player_id)
    TurnTracker.end_turn(game_id: game_id, player_id: player_id)
  end
end
