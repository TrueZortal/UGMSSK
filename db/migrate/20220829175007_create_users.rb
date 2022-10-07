# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.integer :game_id
      t.text :uuid, unique: true, null: false
      t.timestamps
    end
  end
end
