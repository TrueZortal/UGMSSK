# frozen_string_literal: true

class BoardState < ApplicationRecord
  def self.create_board(game_id: nil, size_of_board_edge: 4)
    board = BoardState.new(game_id: game_id)
    board.save
    generate_board_fields(size_of_board_edge, game_id)
    make_dijkstra_information(game_id)
  end

  # takes game_id
  # generates a routing hash for use in djikstra pathfinding
  def self.make_dijkstra_information(game_id)
    routing = {}
    field_index = []
    all_fields_array = BoardField.where(game_id: game_id).to_a
    all_fields_array.each do |field|
      all_fields_array.each do |another_field|
        weight = Calculations.distance(field, another_field)
        next unless Calculations.distance(field,
                                          another_field) < 1.42 && (field != another_field && field.obstacle == false && another_field.obstacle == false)

        from = [field.x_position, field.y_position]
        to = [another_field.x_position, another_field.y_position]
        if !routing.key?(from)
          routing[from] = { to => weight }
        else
          routing[from][to] = weight
        end

        if !routing.key?(to)
          routing[to] = { from => weight }
        else
          routing[to][from] = weight
        end
        field_index << from unless field_index.include?(from)
        field_index << to unless field_index.include?(to)
      end
    end
    pathfinding_data = JSON.generate(routing)
    BoardState.find_by(game_id: game_id).update(pathfinding_data: pathfinding_data)
  end

  # takes: integer size of board edge, integer game_id
  # returns: creates boardfield rows with appropriate parameters
  def self.generate_board_fields(size_of_board_edge, game_id)
    obstacles = 0
    valid_obstacle_coordinates = find_valid_obstacle_placement(size_of_board_edge)
    obstacle_limit = valid_obstacle_coordinates.size / 4 + 1

    size_of_board_edge.times do |x|
      size_of_board_edge.times do |y|
        chosen_terrain = if valid_obstacle_coordinates.include?([x, y]) && obstacles < obstacle_limit
                           terrain_with_obstacle_chance_selector
                         else
                           terrain_selector
                         end

        obstacles += 1 if is_obstacle(chosen_terrain)

        field = BoardField.new(
          game_id: game_id,
          x_position: x,
          y_position: y,
          status: '',
          occupant_type: '',
          occupant_id: nil,
          terrain: chosen_terrain,
          obstacle: is_obstacle(chosen_terrain),
          offset: choose_offset(chosen_terrain),
          occupied: is_obstacle(chosen_terrain)
        )
        field.save
      end
    end
  end

  # takes: game_id
  # returns: array of lines for rendering
  def self.arrayify_for_rendering(game_id: nil)
    rendering_array = []
    board_fields = BoardField.where(game_id: game_id)
    size_of_board_edge = Math.sqrt(board_fields.size).to_i
    size_of_board_edge.times do |x|
      temp_array = []
      size_of_board_edge.times do |y|
        temp_array << board_fields.find_by(x_position: x, y_position: y)
      end
      rendering_array << temp_array
    end
    rendering_array
  end

  # takes: String terrain type
  # returns: Boolean of obstacle
  def self.is_obstacle(terrain_string)
    obstacles = %w[
      tree
      house
    ]
    obstacles.include?(terrain_string)
  end

  # returns: String chosen field terrain based on the last field with chance of returning obstacle
  def self.terrain_with_obstacle_chance_selector
    chosen_terrain = terrain_selector
    generation_key = {
      'grass': { 'tree': 3, 'house': 1, 'grass': 10 },
      'dirt': { 'tree': 1, 'house': 1, 'dirt': 10 },
      'tree': { 'tree': 5, 'house': 1, 'dirt': 3, 'grass': 10 },
      'house': { 'grass': 10, 'house': 3, 'dirt': 5 }
    }

    field_pool = []
    generation_key[chosen_terrain.to_sym].map do |terrain, weight|
      weight.times { field_pool << terrain }
    end
    field_pool.sample.to_s
  end

  # returns: String chosen field terrain based on the last field
  def self.terrain_selector
    generation_key = {
      'grass': { 'grass': 15, 'dirt': 1 },
      'dirt': { 'dirt': 1, 'grass': 1 },
      'house': { 'grass': 15, 'dirt': 1 },
      'tree': { 'grass': 15, 'dirt': 1 }
    }

    if BoardField.all.empty?
      'grass'
    else
      field_pool = []
      generation_key[BoardField.last.terrain.to_sym].map do |terrain, weight|
        weight.times { field_pool << terrain }
      end
      field_pool.sample
    end
  end

  # takes: string terrain
  # returns: string offset for rendering
  def self.choose_offset(terrain)
    offset_dictionary = {
      'grass': { "-128px -0px": 12, "-192px -0px": 1, "-256px -0px": 1, "-0px -0px": 1 },
      'dirt': { "-64px -0px": 5, "-320px -0px": 1 },
      'tree': { "-384px -0px": 1 },
      'house': { "-448px -0px": 1 }
    }

    field_pool = []
    offset_dictionary[terrain.to_sym].map do |offset, weight|
      weight.times { field_pool << offset }
    end
    field_pool.sample
  end

  # takes: integer size of board edge,
  # returns: array of arrays [x,y] of coordinates of valid obstacle placements
  def self.find_valid_obstacle_placement(size_of_board_edge)
    max = size_of_board_edge - 1
    array = *(0..max).to_a
    limit = Math.sqrt(array.size).to_i
    lower_bound = array[0..limit - 1]
    upper_bound = array[0 - limit..]
    centre = array - (lower_bound + upper_bound)
    temp_array = []
    centre.each do |x|
      centre.each do |y|
        temp_array << [x, y]
      end
    end
    temp_array
  end
end

