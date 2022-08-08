# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../field'

class FieldTest < Minitest::Test
  def test_can_create_a_new_field_with_default_values
    test = Field.new
    assert_equal 0, test.position.x
    assert_equal 0, test.position.y
    assert_equal 'empty', test.status
    assert_equal '', test.terrain
    assert_equal '', test.occupant
    assert_equal false, test.obstacle
  end

  def test_can_create_a_new_field_with_custom_coordinates
    test = Field.new(x: 3, y: 4)
    assert_equal 3, test.position.x
    assert_equal 4, test.position.y
  end
end
