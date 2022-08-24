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
    TurnTracker.where(game_id: game_id, complete: false).first.player_id
  end

  def self.end_turn(game_id: nil, player_id: nil)
    TurnTracker.find_by(game_id: game_id, player_id: player_id, complete: false).update(complete: true)
  end
end

