# frozen_string_literal: true

class TurnTracker < ApplicationRecord
  def self.current_turn_complete_or_doesnt_exist?(game_id)
    TurnTracker.where(game_id: game_id, complete: false).to_a.empty?
  end

  def self.pull_current_player_id(game_id: nil)
    if current_turn_complete_or_doesnt_exist?(game_id)
      Game.move_game_to_next_turn(game_id: game_id)
      game = Game.find(game_id)
      game.player_ids.shuffle.each do |player|
        player_turn = TurnTracker.new(game_id: game_id, turn_number: game.current_turn, player_id: player)
        player_turn.save
      end
    end
    PvpPlayers.find(TurnTracker.where(game_id: game_id, complete: false).first.player_id)
  end

  def self.end_turn(game_id: nil, player_id: nil)
    Game.remove_players_who_lost(game_id: game_id)
    Game.check_and_update_minions_who_can_attack(game_id: game_id)
    check_win_conditions(game_id: game_id)
    PvpPlayers.check_and_set_available_player_actions(game_id: game_id)
    TurnTracker.find_by(game_id: game_id, player_id: player_id, complete: false).update(complete: true)

  end

  def self.check_win_conditions(game_id: nil)
    players = Game.find(game_id).player_ids
    EventLog.winner(player_db_record: PvpPlayers.find(players[0])) if players.size == 1
    if players.size == 1
      Game.find(game_id).update(underway: false)
    end
  end
end
