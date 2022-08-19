class PvpPlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :pvp_players do |t|
      t.integer :game_id, null: true
      t.string :name, null: false
      t.integer :mana, null: false
      t.integer :max_mana, null: false
      t.string :summoning_zone, null: false
      t.timestamps
    end
  end
end