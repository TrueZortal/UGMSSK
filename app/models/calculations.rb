# frozen_string_literal: true

class Calculations < ApplicationRecord
  def self.distance(field_record, another_field_record)
    Math.sqrt((another_field_record.x_position - field_record.x_position)**2 + (another_field_record.y_position - field_record.y_position)**2)
  end
end
