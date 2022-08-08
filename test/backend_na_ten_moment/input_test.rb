# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../input'
require_relative '../menu'

class InputTest < Minitest::Test
  def test_if_getting_input_is_testable
    value = 'command_input_thing_standardIO_thing'
    test_input_stream = StringIO.new(value)
    assert_equal value, Input.new(input: test_input_stream).get
  end

  def test_input_defaults_to_gets_if_command_queue_is_empty
    test_command_queue = CommandQueue.new
    value = 'test input'
    test_input_stream = StringIO.new(value)
    assert_equal value, Input.get(input: test_input_stream)
  end

  def test_input_pulls_element_from_command_queue_if_available
    value = 'test_input'
    test_queue = Menu.instance.command_queue
    test_queue.add(value)
    assert_equal value, Input.get
    test_queue.clear
  end
end
