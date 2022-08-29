class AddValidMovesToSummonedMinion < ActiveRecord::Migration[7.0]
  def change
    add_column :summoned_minions, :valid_moves, :integer, array: true, default: []
  end
end
