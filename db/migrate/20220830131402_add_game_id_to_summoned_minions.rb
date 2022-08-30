class AddGameIdToSummonedMinions < ActiveRecord::Migration[7.0]
  def change
    add_column :summoned_minions, :game_id, :integer, null: false
  end
end
