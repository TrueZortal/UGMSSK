# frozen_string_literal: true

class TurnTracker < ApplicationRecord
  def self.create_turn_or_pull_current_player_if_turn_exists(game_id: nil)
    check_if_current_turn_exists_and_create_new_if_it_doesnt(game_id: game_id)
    current_player = PvpPlayers.find(TurnTracker.where(game_id: game_id, complete: false).first.player_id)
    GameManager::SetCurrentPlayer.call(game_id, current_player.id)
    current_player
  end

  def self.end_turn(game_id: nil, player_id: nil)
    Game.end_turn(game_id: game_id)
    if TurnTracker.exists?(game_id: game_id, player_id: player_id, complete: false)
      TurnTracker.find_by(game_id: game_id, player_id: player_id, complete: false).update(complete: true)
    end
  end

  class << self
    private

    def check_if_current_turn_exists_and_create_new_if_it_doesnt(game_id: nil)
      if current_turn_complete_or_doesnt_exist?(game_id)
        GameManager::MoveToNextTurn.call(game_id)
        create_turns_for_all_players_in_game(game_id: game_id)
      end
    end

    def current_turn_complete_or_doesnt_exist?(game_id)
      TurnTracker.where(game_id: game_id, complete: false).to_a.empty?
    end

    def create_turns_for_all_players_in_game(game_id: nil)
      game = Game.find(game_id)
      game.player_ids.shuffle.each do |player|
        player_turn = TurnTracker.new(game_id: game_id, turn_number: game.current_turn, player_id: player)
        player_turn.save
      end
    end
  end
end
