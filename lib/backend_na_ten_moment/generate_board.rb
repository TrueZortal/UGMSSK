# frozen_string_literal: true

require_relative 'field'
require_relative 'calculations'

class InvalidMovementError < StandardError
end

class OutOfRangeError < StandardError
end

class InvalidTargetError < StandardError
end

class InvalidPositionError < StandardError
end

class GenerateBoard
  attr_accessor :rowified, :array_of_fields, :pathfinding_data

  def initialize(size_of_board_edge, uniform, starting_surface)
    raise ArgumentError unless size_of_board_edge > 1

    @size_of_board_edge = size_of_board_edge
    @upper_limit = @size_of_board_edge - 1
    @uniform = uniform
    @starting_surface = starting_surface
    generate_an_array_of_fields(size_of_board_edge)
    rowify_the_array_of_fields
    add_obstacles_in_the_non_starting_areas if @uniform == false
    generate_a_pathfinding_array
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

  def generate_an_array_of_fields(size_of_board_edge)
    @array_of_fields = []
    size_of_board_edge.times do |x|
      size_of_board_edge.times do |y|
        chosen_terrain = terrain_selector
        @array_of_fields << Field.new(x: x, y: y, terrain: chosen_terrain, obstacle: is_an_obstacle?(chosen_terrain))
      end
    end
    @array_of_fields
  end

  def add_obstacles_in_the_non_starting_areas
    generation_key = {
      'grass': { 'tree': 3, 'house': 1, 'grass': 10 },
      'dirt': { 'tree': 1, 'house': 1, 'dirt': 10 }
    }
    obstacle_limit = find_valid_obstacle_placement.size / 4 + 1
    set_valid_obstacle_placements_to_be_fields.shuffle.each do |field|
      field_pool = []
      generation_key[field.terrain.to_sym].map do |terrain, weight|
        weight.times { field_pool << terrain }
      end
      resulting_field = field_pool.sample.to_s
      next unless is_an_obstacle?(resulting_field)

      obstacle_limit -= 1
      if obstacle_limit.positive?
        field.obstacle = true
        field.terrain = resulting_field
      end
    end
  end

  def terrain_selector
    # 'rock': {'grass': 3,'rock': 1}
    generation_key = {
      'grass': { 'grass': 6, 'dirt': 1 },
      'dirt': { 'dirt': 2, 'grass': 1 }
    }

    if @array_of_fields.empty? || @uniform == true
      @starting_surface
    else
      field_pool = []
      generation_key[@array_of_fields.last.terrain.to_sym].map do |terrain, weight|
        weight.times { field_pool << terrain }
      end
      field_pool.sample
    end
  end

  def rowify_the_array_of_fields
    @rowified = []
    Math.sqrt(@array_of_fields.size).to_i.times do
      empty_column = []
      @rowified << empty_column
    end
    @array_of_fields.each do |field|
      @rowified[field.position.x] << field
    end
    @rowified
  end

  def set_valid_obstacle_placements_to_be_fields
    coordinate_array_of_valid_obstacle_fields = []
    find_valid_obstacle_placement.each do |centre_field|
      coordinate_array_of_valid_obstacle_fields << @rowified[centre_field[0]][centre_field[1]]
    end
    coordinate_array_of_valid_obstacle_fields
  end

  def find_valid_obstacle_placement
    array = *(0..@upper_limit).to_a
    limit = Math.sqrt(array.size).to_i
    lower_bound = array[0..limit - 1]
    upper_bound = array[0 - limit..]
    centre = array - (lower_bound + upper_bound)
    Calculations.combine_arrays(centre, centre)
  end

  def set_summoning_zones_to_be_positions
    coordinate_array_of_summoning_zones = find_summoning_zone_coordinate_arrays
    coordinate_array_of_summoning_zones.each do |summoning_zone|
      summoning_zone.map! { |coordinates_array| @rowified[coordinates_array[0]][coordinates_array[1]].position }
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

  def is_an_obstacle?(terrain)
    obstacles = %w[
      tree
      house
    ]
    obstacles.include?(terrain)
  end
end
