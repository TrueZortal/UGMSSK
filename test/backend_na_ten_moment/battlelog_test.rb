# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../battlelog'

class LogTest < Minitest::Test
  def test_a_new_log_can_be_created
    test_log = BattleLog.new
    assert_instance_of BattleLog, test_log
  end

  def test_a_new_log_has_a_log_thats_an_empty_hash
    test_log = BattleLog.new
    assert_equal [], test_log.log
  end

  def test_strings_can_be_added_to_the_log
    test_log = BattleLog.new
    message = 'test log entry'
    test_log.add(message)
    assert_equal message, test_log.log.first
  end

  def test_log_has_a_timestamp
    test_log = BattleLog.new
    time = Time.now.to_i
    assert_equal time, test_log.time.to_i
  end

  def test_log_can_print_in_order
    time1 = Time.now.to_i
    test_log = BattleLog.new
    message = 'test log entry'
    second_message = 'second test log entry'
    third_message = 'third test log entry'
    test_log.add(message)
    test_log.add(second_message)
    test_log.add(third_message)
    expected_log = "**#{test_log.time.utc} BattleLog**\nMOVE 1:test log entry\nMOVE 2:second test log entry\nMOVE 3:third test log entry\n------------"
    assert_equal expected_log, test_log.print
  end
end
