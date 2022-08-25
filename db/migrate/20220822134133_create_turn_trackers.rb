# frozen_string_literal: true

class CreateTurnTrackers < ActiveRecord::Migration[7.0]
  def change
    create_table :turn_trackers do |t|
      t.integer :game_id, null: true
      t.integer :turn_number, null: true
      t.string :player_name, null: false
      t.boolean :complete, default: false
      t.timestamps
    end
  end
end
