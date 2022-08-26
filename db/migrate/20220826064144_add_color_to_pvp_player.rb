class AddColorToPvpPlayer < ActiveRecord::Migration[7.0]
  def change
    add_column :pvp_players, :color, :string
  end
end
