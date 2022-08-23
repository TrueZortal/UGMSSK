class AddMinionTypeToMinionStats < ActiveRecord::Migration[7.0]
  def change
    add_column :minion_stats, :minion_type, :string
  end
end
