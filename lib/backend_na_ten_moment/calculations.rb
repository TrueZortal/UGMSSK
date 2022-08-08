# frozen_string_literal: true

class Calculations
  def self.combine_arrays(bound1, bound2)
    temp_array = []
    bound1.each do |x|
      bound2.each do |y|
        temp_array << [x, y]
      end
    end
    temp_array
  end
end
