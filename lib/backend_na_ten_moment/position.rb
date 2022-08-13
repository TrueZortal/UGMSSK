# frozen_string_literal: true

class InvalidPositionError < StandardError
end

class Position
  attr_accessor :x, :y, :to_a

  def initialize(x = 0, y = 0, position_json: '')
    raise InvalidPositionError if !x.nil? && x.negative? || !y.nil? && y.negative?

    @position_json = position_json
    if @position_json != ''
      hash_from_json
    else
      @x = x
      @y = y
      @to_a = [x, y]
    end
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def hash_from_json
    hash_of_position = JSON.parse(@position_json)
    @x = hash_of_position['x']
    @y = hash_of_position['y']
    @to_a = [@x, @y]
  end

  def distance(other_position)
    Math.sqrt((other_position.x - x)**2 + (other_position.y - y)**2)
  end

  def get_valid_routes(other_position)
    valid_routes = []
    valid_routes << get_route_to(other_position)
    valid_routes << other_position.get_route_to(self)
    valid_routes
  end

  def get_route_to(other_position)
    relative_position = distance_between_position_arrays_as_relative_position_array(other_position.to_a)
    @coordinates_between = []
    temp_position = other_position.to_a
    until relative_position == [0, 0]
      change_of_x = decide_modifier(relative_position[0])
      change_of_y = decide_modifier(relative_position[1])
      temp_position = [temp_position[0] + change_of_x, temp_position[1] + change_of_y]
      @coordinates_between << temp_position
      relative_position = distance_between_position_arrays_as_relative_position_array(temp_position)
    end
    @coordinates_between - [@to_a]
  end

  def make_json
    position_json = {
      x: @x,
      y: @y,
      to_a: @to_a
    }
    JSON.generate(position_json)
  end

  private

  def decide_modifier(value)
    if value.negative?
      -1
    elsif value.positive?
      1
    else
      0
    end
  end

  def distance_between_position_arrays_as_relative_position_array(other_position_array)
    [@x - other_position_array[0], @y - other_position_array[1]]
  end
end
