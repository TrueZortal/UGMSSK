# frozen_string_literal: true

class CreateSummonedMinions < ActiveRecord::Migration[7.0]
  def change
    create_table :summoned_minions do |t|
      t.integer :owner_id, null: true # references user:id
      t.string :owner, null: true # references Player:name
      t.string :minion_type, null: false
      t.integer :health, null: false
      t.integer :x_position, null: false
      t.integer :y_position, null: false
      t.timestamps
    end
  end
end
