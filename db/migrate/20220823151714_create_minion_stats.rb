# frozen_string_literal: true

class CreateMinionStats < ActiveRecord::Migration[7.0]
  def change
    create_table :minion_stats do |t|
      t.integer :mana_cost, null: false
      t.integer :health, null: false
      t.integer :attack, null: false
      t.integer :defense, null: false
      t.integer :speed, null: false
      t.integer :initiative, null: false
      t.integer :range, null: false
      t.timestamps
    end
  end
end

# minion_data = {
#       'skeleton': { mana_cost: 1, health: 5, attack: 1, defense: 0, speed: 2, initiative: 3, range: 1.5 },
#       'skeleton archer': { mana_cost: 2, health: 2, attack: 2, defense: 0, speed: 1, initiative: 3,
#                            range: 3 }
#     }

# MinionStat.new(minion_type: 'skeleton archer', mana_cost: 2, health: 2, attack: 2, defense: 0, speed: 1, initiative: 3, range: 3,icon: '64x64Skelly.png')
# MinionStat.new(minion_type: 'skeleton', mana_cost: 1, health: 5, attack: 1, defense: 0, speed: 2, initiative: 3, range: 1.5, icon: '64x64SkellyArcher.png')
# MinionStat.find_by(minion_type: 'skeleton').update(icon: '64x64Skelly.png')
# MinionStat.find_by(minion_type: 'skeleton archer').update(icon: '64x64SkellyArcher.png')
