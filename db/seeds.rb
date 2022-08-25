# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

MinionStat.destroy_all

MinionStat.create!([{
                     minion_type: 'skeleton archer', mana_cost: 2, health: 2, attack: 2, defense: 0, speed: 1, initiative: 3, range: 3, icon: '64x64SkellyArcher.png'
                   },
                    {
                      minion_type: 'skeleton', mana_cost: 1, health: 5, attack: 1, defense: 0, speed: 2, initiative: 3, range: 1.5, icon: '64x64Skelly.png'
                    }])

p "Created #{MinionStat.count} basic biiii...Minions"
