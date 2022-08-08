# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../calculations'

class CalculationsTest < Minitest::Test
  def test_arrays_are_correctly_combined
    array1 = [1, 2]
    array2 = [3, 4]
    expected = [[1, 3], [1, 4], [2, 3], [2, 4]]
    assert_equal expected, Calculations.combine_arrays(array1, array2)
  end
end
