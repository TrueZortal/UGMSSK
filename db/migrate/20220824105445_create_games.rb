# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :player_ids, array: true, default: []
      t.integer :current_turn, default: 0
      t.integer :current_player_id
      t.timestamps
    end
  end
end
