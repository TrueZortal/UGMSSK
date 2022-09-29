class AddSummoningZoneArrayToBoardState < ActiveRecord::Migration[7.0]
  def change
    add_column :board_states, :summoning_zones, :string, array: true, default: []
  end
end
