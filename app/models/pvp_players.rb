# frozen_string_literal: true

class PvpPlayers < ApplicationRecord
  # validates :board, presence: true
  def self.add_player(game_id)
    if PvpPlayers.where(game_id: game_id).size < 4
      added_player = PvpPlayers.new(name: "Player#{PvpPlayers.all.size + 1}", mana: 10, max_mana: 10,
                                    summoning_zone: '', game_id: game_id)
      added_player.save
      Game.find(game_id).player_ids.push(added_player.id)
    end
  end

  def remove_player(game_id)
    PvpPlayers.where(game_id: game_id).last.destroy if PvpPlayers.where(game_id: game_id).size > 2
  end
end
