# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../menu'

class MenuTest < Minitest::Test
  def test_a_new_game_can_be_started_and_ended_between_4_players
    skip
    list_of_test_inputs = %w[PVP 4 8 cool M 10 T 10 Z 10 Q 10 concede concede concede
                             concede no]
    Menu.instance.command_queue.bulk_add(list_of_test_inputs)
    Menu.instance.display_menu
  end

  def test_a_new_game_can_be_started_and_ended_between_4_players
    # skip
    # concede clause: , 'concede', 'concede', 'no'
    list_of_test_inputs = ['debug_pvp', '2', '4', 'boring', 'M', '5', 'D', '5', 'summon', 'skeleton archer', '2,1', 'summon',
                           'skeleton archer', '3,3', 'summon', 'skeleton', '3,1', 'move', '0', '2,3', 'summon', 'skeleton archer', '2,0', 'attack', '0', '0', 'attack', 'attack', 'move', '0', '2,0', 'summon', 'skeleton archer', '3,3', 'attack', '0', '0', 'summon', 'skeleton', '3,2', 'attack','1','0','attack','0','0','attack','0','0','attack','0','0','attack','0','0', 'concede', 'no']
    Menu.instance.command_queue.bulk_add(list_of_test_inputs)
    Menu.instance.display_menu
  end
end

