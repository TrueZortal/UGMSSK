# frozen_string_literal: true

class AddUserIdToPvpPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :pvp_players, :uuid, :text, null: false
    add_column :games, :underway, :boolean, default: false
  end
end
