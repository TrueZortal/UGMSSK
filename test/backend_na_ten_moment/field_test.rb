# frozen_string_literal: true

require 'minitest/autorun'
# require_relative '../field'

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

  def test_field_can_be_recreated_from_json
    field_json = Field.new.make_json
    test_field = Field.new(field_json: field_json)
    assert_equal test_field.make_json, field_json
  end

  # def test_field_with_a_minion_can_be_recreated_from_json
  #
  #   field_json = "{\"position\":\"{\\\"x\\\":0,\\\"y\\\":0,\\\"to_a\\\":[0,0]}\",\"status\":\"empty\",\"occupant\":\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":0,\\\\\\\"y\\\\\\\":0,\\\\\\\"to_a\\\\\\\":[0,0]}\\\",\\\"owner\\\":\\\"Player1\\\",\\\"type\\\":\\\"skeleton\\\",\\\"health\\\":5}\",\"terrain\":\"grass\",\"obstacle\":false,\"offset\":\"-128px -0px\"}"
  #     #   test_field = Field.new(field_json: field_json)
  #   assert_equal test_field.make_json, field_json
  # end
end
