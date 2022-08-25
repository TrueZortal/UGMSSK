# frozen_string_literal: true

class AddIconsToMinionStats < ActiveRecord::Migration[7.0]
  def change
    add_column :minion_stats, :icon, :string
  end
end
