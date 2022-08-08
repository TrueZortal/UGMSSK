# frozen_string_literal: true

require_relative 'render_board'
require_relative 'generate_board'

class InvalidMovementError < StandardError
end

class OutOfRangeError < StandardError
end

class InvalidTargetError < StandardError
end

class InvalidPositionError < StandardError
end

# working surface for board is @rowified_board, Observers are empowered via @array_of_fields
class Board
  attr_reader :upper_limit, :array_of_fields, :summoning_zones, :pathfinding_data, :array_of_coordinates
  attr_accessor :rowified_board

  def initialize(size_of_board_edge, uniform: true, starting_surface: 'grass')
    raise ArgumentError unless size_of_board_edge > 1

    @board = GenerateBoard.new(size_of_board_edge, uniform, starting_surface)
    @pathfinding_data = @board.pathfinding_data
    @array_of_fields = @board.array_of_fields
    @array_of_coordinates = @array_of_fields.map { |field| field.position.to_a }
    @rowified_board = @board.rowified
    @size_of_board_edge = size_of_board_edge
    @upper_limit = @size_of_board_edge - 1
    @summoning_zones = @board.starting_summoning_zones
  end

  def render_board
    RenderBoard.render(@rowified_board)
  end

  def state
    @rowified_board
  end

  def field_at(position_object)
    @rowified_board[position_object.x][position_object.y]
  end

  def position_at(array_of_xy)
    @rowified_board[array_of_xy[0]][array_of_xy[1]].position
  end

  def check_field(position_object)
    unless position_object.to_a.size == 2 && position_object.to_a.first <= @upper_limit && position_object.to_a.last <= @upper_limit
      raise InvalidPositionError
    end

    @rowified_board[position_object.x][position_object.y]
  end

  def valid_position(position)
    position.to_a.none? { |coordinate_value| coordinate_value > @upper_limit }
  end

  def grab_a_starting_summoning_zone
    @summoning_zones = @summoning_zones.shuffle
    zone = @summoning_zones.pop
    zone.map(&:to_a)
  end

  def zone_message(zone)
    zone_edge = Math.sqrt(@size_of_board_edge).to_i
    "Your summoning zone is #{identify_starting_zone(zone)} and has a size of #{zone_edge}x#{zone_edge} squares"
  end

  private

  def identify_starting_zone(zone)
    if zone.include?([0, 0])
      'top left'
    elsif zone.include?([@upper_limit, 0])
      'top right'
    elsif zone.include?([0, @upper_limit])
      'bottom left'
    elsif zone.include?([@upper_limit, @upper_limit])
      'bottom right'
    end
  end
end

# Board.new(16).find_valid_obstacle_placements
