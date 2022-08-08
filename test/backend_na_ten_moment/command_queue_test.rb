# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../command_queue'

class CommandQueueTest < Minitest::Test
  def test_command_queue_can_be_queried_if_empty
    test = CommandQueue.new
    assert test.empty?
  end

  def test_command_queue_can_have_commands_added
    test = CommandQueue.new
    elem = 'test string'
    test.add(elem)
    refute test.empty?
  end

  def test_command_queue_accepts_array_of_strings_as_an_argument
    array_of_elems = ['test string', 'another test string', 'yet another test string',
                      'i should most likely make those shorter shouldnt i?']
    test = CommandQueue.new(array_of_elems)
    assert_equal 4, test.size
  end

  def test_commands_can_be_popped
    array_of_elems = ['test string', 'another test string', 'yet another test string',
                      'i should most likely make those shorter shouldnt i?']
    test = CommandQueue.new(array_of_elems)
    test.pop
    assert_equal 3, test.size
  end

  def test_commands_can_be_popped_out_of_the_queue
    # skip
    array_of_elems = ['1test string', '2another test string', '3yet another test string',
                      '4i should most likely make those shorter shouldnt i?']
    test = CommandQueue.new(array_of_elems)
    assert_equal array_of_elems[0], test.pop
    assert_equal array_of_elems[1], test.pop
    assert_equal array_of_elems[2], test.pop
    assert_equal array_of_elems[3], test.pop
    assert test.empty?
  end

  def test_commands_can_be_bulk_added_to_the_queue
    # skip
    array_of_elems = ['1test string', '2another test string', '3yet another test string',
                      '4i should most likely make those shorter shouldnt i?']
    test = CommandQueue.new.bulk_add(array_of_elems)
    assert_equal 4, test.size
  end
end
