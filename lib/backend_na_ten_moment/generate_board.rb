# frozen_string_literal: true

require_relative 'field'
require_relative 'minion'
require_relative 'position'
# require_relative 'calculations'

class InvalidMovementError < StandardError
end

class OutOfRangeError < StandardError
end

class InvalidTargetError < StandardError
end

class InvalidPositionError < StandardError
end

# generate and prepare render pattern of board
class GenerateBoard
  attr_accessor :columnised, :array_of_fields, :pathfinding_data

  def initialize(size_of_board_edge = 4, uniform = false, starting_surface = 'grass', board_json: '')
    raise ArgumentError unless size_of_board_edge > 1

    @board_json = board_json
    if @board_json != ''
      remake_fields_from_json
      columnize_the_array_of_fields
      generate_a_pathfinding_array
      update_minion_boards_to_self
      @upper_limit = @size_of_board_edge - 1
    else
      @size_of_board_edge = size_of_board_edge
      @upper_limit = @size_of_board_edge - 1
      @uniform = uniform
      @starting_surface = starting_surface
      generate_an_array_of_fields(size_of_board_edge)
      columnize_the_array_of_fields
      add_obstacles_in_the_non_starting_areas if @uniform == false
      set_offsets
      generate_a_pathfinding_array
    end
    save_board_state
  end

  def generate_array_of_fields_from_json
    @hash_of_board = JSON.parse(@board_json)
    @array_of_fields = []
    @hash_of_board['fields'].each do |json_of_field|
      @array_of_fields << Field.new(field_json: json_of_field)
    end
    @size_of_board_edge = Math.sqrt(@array_of_fields.size).to_i
    @array_of_fields
  end

  def remake_fields_from_json
    generate_array_of_fields_from_json
  end

  def update_minion_boards_to_self
    @array_of_fields.filter(&:occupied?).each do |field|
      field.occupant.update_board(self)
      field.occupant
    end
  end

  def make_json
    board_json = {
      size_of_board_edge: @size_of_board_edge,
      fields: make_json_of_fields
    }
    JSON.generate(board_json)

    # board_json
  end

  def save_board_state
    build_boardstate = BoardState.new(board: make_json)
    build_boardstate.save
  end

  def make_json_of_fields
    @array_of_fields.map(&:make_json)
  end

  def starting_summoning_zones
    set_summoning_zones_to_be_positions
  end

  def generate_a_pathfinding_array
    @routing = {}
    @field_index = []
    add_edges
    @pathfinding_data = [@routing, @field_index]
  end

  private

  def add_edges
    @array_of_fields.each do |field|
      @array_of_fields.each do |another_field|
        if field.position.distance(another_field.position) < 1.42 && (field != another_field && field.obstacle == false && another_field.obstacle == false)
          add_edge(field, another_field,
                   field.position.distance(another_field.position))
        end
      end
    end
  end

  def add_edge(source, target, weight)
    if !@routing.key?(source)
      @routing[source] = { target => weight }
    else
      @routing[source][target] = weight
    end
    if !@routing.key?(target)
      @routing[target] = { source => weight }
    else
      @routing[target][source] = weight
    end
    @field_index << source unless @field_index.include?(source)
    @field_index << target unless @field_index.include?(target)
  end

  def set_summoning_zones_to_be_positions
    coordinate_array_of_summoning_zones = find_summoning_zone_coordinate_arrays
    coordinate_array_of_summoning_zones.each do |summoning_zone|
      summoning_zone.map! { |coordinates_array| @columnised[coordinates_array[0]][coordinates_array[1]].position }
    end
    coordinate_array_of_summoning_zones
  end

  def find_summoning_zone_coordinate_arrays
    array = *(0..@upper_limit).to_a
    limit = Math.sqrt(array.size).to_i
    lower_bound = array[0..limit - 1]
    upper_bound = array[0 - limit..]
    array_of_summoning_zones = []
    array_of_summoning_zones << Calculations.combine_arrays(upper_bound, lower_bound)
    array_of_summoning_zones << Calculations.combine_arrays(lower_bound, lower_bound)
    array_of_summoning_zones << Calculations.combine_arrays(lower_bound, upper_bound)
    array_of_summoning_zones << Calculations.combine_arrays(upper_bound, upper_bound)
    array_of_summoning_zones
  end
end
