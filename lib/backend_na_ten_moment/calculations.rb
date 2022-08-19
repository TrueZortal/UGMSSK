# frozen_string_literal: true

# holding all recurring calculation methods
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

  def self.to_a(string)
    if string.empty?
      string
    else
      array = []
      string.split('], [').to_a.each do |coord|
        array << coord.gsub(/[^,0-9]/, '').split(',').map(&:to_i)
      end
      array
    end
  end
end
