# frozen_string_literal: true

class CreateEventLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :event_logs do |t|
      t.integer :game_id, null: true # will have to reference game_id once implemented
      t.string :event, null: false
      t.timestamps
    end
  end
end
