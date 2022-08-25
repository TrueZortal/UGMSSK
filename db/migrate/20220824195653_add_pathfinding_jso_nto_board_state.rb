# frozen_string_literal: true

class AddPathfindingJsoNtoBoardState < ActiveRecord::Migration[7.0]
  def change
    add_column :board_states, :pathfinding_data, :json
  end
end
