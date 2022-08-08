# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../pvp'

class PVPTest < Minitest::Test
  def test_can_correctly_start_a_new_pvp_game
    skip
    string_io = StringIO.new
    string_io.puts 'Mateusz'
    string_io.puts '10'
    string_io.puts 'Michal'
    string_io.puts '10'
    string_io.rewind
    $stdin = string_io
    test_match = PVP.new
    $stdin = STDIN
    assert_instance_of PVP, test_match
  end

  def test_correctly_starts_a_new_game_with_default_number_of_players
    skip
    string_io = StringIO.new
    string_io.puts 'Mateusz'
    string_io.puts '10'
    string_io.puts 'Michal'
    string_io.puts '10'
    string_io.rewind
    $stdin = string_io
    test_match = PVP.new
    $stdin = STDIN
    assert_equal 2, test_match.game.players.size
  end

  def test_correctly_starts_first_turn_after_player_selection; end
end
