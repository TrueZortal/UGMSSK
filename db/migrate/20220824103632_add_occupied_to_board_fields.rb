class AddOccupiedToBoardFields < ActiveRecord::Migration[7.0]
  def change
    add_column :board_fields, :occupied, :boolean, default: false
  end
end
