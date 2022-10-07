# frozen_string_literal: true

require 'minitest/autorun'

class UserTest < Minitest::Test
  def test_should_not_be_valid_without_uuid
    user = User.new(name: 'example')
    refute user.valid?
  end

  def test_should_not_be_valid_without_name
    user = User.new(uuid: SecureRandom.uuid)
    refute user.valid?
  end

  def test_should_be_valid_with_name_and_uuid
    user = User.new(name: 'example', uuid: SecureRandom.uuid)
    assert user.valid?
  end
end
