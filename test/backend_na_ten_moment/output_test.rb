# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../output'

class OutputTest < Minitest::Test
  def test_interface_returns_its_input_to_std_output
    value = 'test outputu'
    test_output_stream = StringIO.new
    Output.new(output: test_output_stream).print(value)
    assert_equal test_output_stream.string, <<~OUTPUT
      #{value}
    OUTPUT
  end
end
