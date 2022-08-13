# frozen_string_literal: true

class CreateBoardStates < ActiveRecord::Migration[7.0]
  def change
    create_table :board_states do |t|
      t.text :board # json of the board

      t.timestamps
    end
  end
end
