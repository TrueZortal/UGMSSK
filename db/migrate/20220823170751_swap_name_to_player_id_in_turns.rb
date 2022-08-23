class SwapNameToPlayerIdInTurns < ActiveRecord::Migration[7.0]
  def change
    remove_column :turn_trackers, :player_name, :string
    add_column :turn_trackers, :player_id, :integer
  end
end
