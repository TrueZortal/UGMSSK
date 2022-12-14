# frozen_string_literal: true

class AddAvailableTargetIdsToSummonedMinions < ActiveRecord::Migration[7.0]
  def change
    add_column :summoned_minions, :available_targets, :integer, array: true, default: []
  end
end
