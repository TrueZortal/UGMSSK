# frozen_string_literal: true

class AddTwoDimensionalArrayOfFieldsAndGameIDtoBoardState < ActiveRecord::Migration[7.0]
  def change
    add_column :board_states, :game_id, :integer
  end
end
