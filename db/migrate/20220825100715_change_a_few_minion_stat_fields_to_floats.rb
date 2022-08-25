# frozen_string_literal: true

class ChangeAFewMinionStatFieldsToFloats < ActiveRecord::Migration[7.0]
  def change
    change_column :minion_stats, :range, :float
    change_column :minion_stats, :speed, :float
  end
end
