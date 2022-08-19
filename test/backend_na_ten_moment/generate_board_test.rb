# frozen_string_literal: true

require 'minitest/autorun'
# require_relative '../generate_board'

class GenerateBoardTest < Minitest::Test
  def test_cant_create_a_board_smaller_than_two_x_two
    assert_raises(ArgumentError) do
      GenerateBoard.new(1)
    end
  end

  def test_creates_a_custom_sized_board
    test = GenerateBoard.new(5, true, 'grass')
    assert_equal 25, test.columnised.flatten.size
  end

  def test_board_correctly_finds_starting_zone_positions
    test = GenerateBoard.new(8, true, 'grass')
    expected = [[[0, 0], [0, 1], [1, 0], [1, 1]], [[0, 6], [0, 7], [1, 6], [1, 7]], [[6, 6], [6, 7], [7, 6], [7, 7]],
                [[6, 0], [6, 1], [7, 0], [7, 1]]]
    assert_empty test.starting_summoning_zones.map { |zone| zone.map(&:to_a) } - expected
  end

  def test_board_generates_from_board_json
    # skip
    board_json = GenerateBoard.new.make_json
    test = GenerateBoard.new(board_json: board_json)
    assert_equal board_json, test.make_json
  end

  # rubocop:disable all
  # def test_minions_maintain_their_spatial_awareness_after_board_is_remade_with_them
  #   board_json = "{\"size_of_board_edge\":4,\"fields\":[\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":0,\\\\\\\"y\\\\\\\":0,\\\\\\\"to_a\\\\\\\":[0,0]}\\\",\\\"status\\\":\\\"empty\\\",\\\"occupant\\\":\\\"{\\\\\\\"position\\\\\\\":\\\\\\\"{\\\\\\\\\\\\\\\"x\\\\\\\\\\\\\\\":0,\\\\\\\\\\\\\\\"y\\\\\\\\\\\\\\\":0,\\\\\\\\\\\\\\\"to_a\\\\\\\\\\\\\\\":[0,0]}\\\\\\\",\\\\\\\"owner\\\\\\\":\\\\\\\"Player1\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"skeleton\\\\\\\",\\\\\\\"health\\\\\\\":5}\\\",\\\"terrain\\\":\\\"grass\\\",\\\"obstacle\\\":false,\\\"offset\\\":\\\"-128px -0px\\\"}\",\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":0,\\\\\\\"y\\\\\\\":1,\\\\\\\"to_a\\\\\\\":[0,1]}\\\",\\\"status\\\":\\\"empty\\\",\\\"occupant\\\":\\\"\\\",\\\"terrain\\\":\\\"grass\\\",\\\"obstacle\\\":false,\\\"offset\\\":\\\"-128px -0px\\\"}\",\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":0,\\\\\\\"y\\\\\\\":2,\\\\\\\"to_a\\\\\\\":[0,2]}\\\",\\\"status\\\":\\\"empty\\\",\\\"occupant\\\":\\\"\\\",\\\"terrain\\\":\\\"grass\\\",\\\"obstacle\\\":false,\\\"offset\\\":\\\"-128px -0px\\\"}\",\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":0,\\\\\\\"y\\\\\\\":3,\\\\\\\"to_a\\\\\\\":[0,3]}\\\",\\\"status\\\":\\\"empty\\\",\\\"occupant\\\":\\\"\\\",\\\"terrain\\\":\\\"grass\\\",\\\"obstacle\\\":false,\\\"offset\\\":\\\"-128px -0px\\\"}\",\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":1,\\\\\\\"y\\\\\\\":0,\\\\\\\"to_a\\\\\\\":[1,0]}\\\",\\\"status\\\":\\\"empty\\\",\\\"occupant\\\":\\\"\\\",\\\"terrain\\\":\\\"grass\\\",\\\"obstacle\\\":false,\\\"offset\\\":\\\"-256px -0px\\\"}\",\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":1,\\\\\\\"y\\\\\\\":1,\\\\\\\"to_a\\\\\\\":[1,1]}\\\",\\\"status\\\":\\\"empty\\\",\\\"occupant\\\":\\\"{\\\\\\\"position\\\\\\\":\\\\\\\"{\\\\\\\\\\\\\\\"x\\\\\\\\\\\\\\\":1,\\\\\\\\\\\\\\\"y\\\\\\\\\\\\\\\":1,\\\\\\\\\\\\\\\"to_a\\\\\\\\\\\\\\\":[1,1]}\\\\\\\",\\\\\\\"owner\\\\\\\":\\\\\\\"Player2\\\\\\\",\\\\\\\"type\\\\\\\":\\\\\\\"skeleton archer\\\\\\\",\\\\\\\"health\\\\\\\":2}\\\",\\\"terrain\\\":\\\"grass\\\",\\\"obstacle\\\":false,\\\"offset\\\":\\\"-128px -0px\\\"}\",\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":1,\\\\\\\"y\\\\\\\":2,\\\\\\\"to_a\\\\\\\":[1,2]}\\\",\\\"status\\\":\\\"empty\\\",\\\"occupant\\\":\\\"\\\",\\\"terrain\\\":\\\"grass\\\",\\\"obstacle\\\":false,\\\"offset\\\":\\\"-128px -0px\\\"}\",\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":1,\\\\\\\"y\\\\\\\":3,\\\\\\\"to_a\\\\\\\":[1,3]}\\\",\\\"status\\\":\\\"empty\\\",\\\"occupant\\\":\\\"\\\",\\\"terrain\\\":\\\"grass\\\",\\\"obstacle\\\":false,\\\"offset\\\":\\\"-128px -0px\\\"}\",\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":2,\\\\\\\"y\\\\\\\":0,\\\\\\\"to_a\\\\\\\":[2,0]}\\\",\\\"status\\\":\\\"empty\\\",\\\"occupant\\\":\\\"\\\",\\\"terrain\\\":\\\"grass\\\",\\\"obstacle\\\":false,\\\"offset\\\":\\\"-128px -0px\\\"}\",\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":2,\\\\\\\"y\\\\\\\":1,\\\\\\\"to_a\\\\\\\":[2,1]}\\\",\\\"status\\\":\\\"empty\\\",\\\"occupant\\\":\\\"\\\",\\\"terrain\\\":\\\"grass\\\",\\\"obstacle\\\":false,\\\"offset\\\":\\\"-128px -0px\\\"}\",\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":2,\\\\\\\"y\\\\\\\":2,\\\\\\\"to_a\\\\\\\":[2,2]}\\\",\\\"status\\\":\\\"empty\\\",\\\"occupant\\\":\\\"\\\",\\\"terrain\\\":\\\"grass\\\",\\\"obstacle\\\":false,\\\"offset\\\":\\\"-128px -0px\\\"}\",\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":2,\\\\\\\"y\\\\\\\":3,\\\\\\\"to_a\\\\\\\":[2,3]}\\\",\\\"status\\\":\\\"empty\\\",\\\"occupant\\\":\\\"\\\",\\\"terrain\\\":\\\"grass\\\",\\\"obstacle\\\":false,\\\"offset\\\":\\\"-128px -0px\\\"}\",\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":3,\\\\\\\"y\\\\\\\":0,\\\\\\\"to_a\\\\\\\":[3,0]}\\\",\\\"status\\\":\\\"empty\\\",\\\"occupant\\\":\\\"\\\",\\\"terrain\\\":\\\"dirt\\\",\\\"obstacle\\\":false,\\\"offset\\\":\\\"-64px -0px\\\"}\",\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":3,\\\\\\\"y\\\\\\\":1,\\\\\\\"to_a\\\\\\\":[3,1]}\\\",\\\"status\\\":\\\"empty\\\",\\\"occupant\\\":\\\"\\\",\\\"terrain\\\":\\\"dirt\\\",\\\"obstacle\\\":false,\\\"offset\\\":\\\"-64px -0px\\\"}\",\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":3,\\\\\\\"y\\\\\\\":2,\\\\\\\"to_a\\\\\\\":[3,2]}\\\",\\\"status\\\":\\\"empty\\\",\\\"occupant\\\":\\\"\\\",\\\"terrain\\\":\\\"dirt\\\",\\\"obstacle\\\":false,\\\"offset\\\":\\\"-64px -0px\\\"}\",\"{\\\"position\\\":\\\"{\\\\\\\"x\\\\\\\":3,\\\\\\\"y\\\\\\\":3,\\\\\\\"to_a\\\\\\\":[3,3]}\\\",\\\"status\\\":\\\"empty\\\",\\\"occupant\\\":\\\"\\\",\\\"terrain\\\":\\\"dirt\\\",\\\"obstacle\\\":false,\\\"offset\\\":\\\"-64px -0px\\\"}\"]}"

  #   test = GenerateBoard.new(board_json: board_json)
  #   player1_minion = test.array_of_fields.filter do |field|
  #                      field.position.to_a && field.occupied? && field.occupant.owner == 'Player1'
  #                    end                     [0].occupant
  #   player2_minion = test.array_of_fields.filter do |field|
  #                      field.position.to_a && field.occupied? && field.occupant.owner == 'Player2'
  #                    end                     [0].occupant
  #   refute_empty player1_minion.fields_with_enemies_in_range
  #   assert_equal player2_minion, player1_minion.fields_with_enemies_in_range[0].occupant
  # end
end
