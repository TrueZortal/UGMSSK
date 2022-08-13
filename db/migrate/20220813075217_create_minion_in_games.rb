# frozen_string_literal: true

class CreateMinionInGames < ActiveRecord::Migration[7.0]
  def change
    create_table :minion_in_games do |t|
      t.string :minion_type, null: false
      t.string :owner, null: false
      t.integer :x, unique: true, null: false
      t.integer :y, unique: true, null: false

      t.timestamps
    end
  end
end
