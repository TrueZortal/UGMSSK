# frozen_string_literal: true

class AddCanAttackToSummonedMinionsAndAvailableActionsToPvpPlayer < ActiveRecord::Migration[7.0]
  def change
    add_column :summoned_minions, :can_attack, :boolean, default: false
    add_column :pvp_players, :available_actions, :text, array: true, default: []
  end
end
