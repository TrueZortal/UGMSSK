# frozen_string_literal: true

class CreateBoardFields < ActiveRecord::Migration[7.0]
  def change
    create_table :board_fields do |t|
      t.integer :game_id, null: true
      t.integer :x_position, null: false
      t.integer :y_position, null: false
      t.string  :status, null: true
      t.string :occupant_type, null: true
      t.integer :occupant_id, null: false
      t.string :terrain, null: false
      t.boolean :obstacle, null: false
      t.string :offset, null: false
      t.timestamps
    end
  end
end
# def initialize(x: 0, y: 0, status: 'empty', occupant: '', terrain: '', obstacle: false, offset: '', field_json: '')
