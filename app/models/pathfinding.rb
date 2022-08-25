class Pathfinding < ApplicationRecord
  def self.find_shortest_path(starting_field, target_field, game_id: nil)
    infinity = 50
    routing = JSON.parse(BoardState.find_by(game_id: game_id).pathfinding_data, {symbolize_nammes: true})#.to_h
    starting_field_address_array = [starting_field.x_position, starting_field.y_position].to_s
    target_field_address_array = [target_field.x_position, target_field.y_position].to_s
    field_index = routing.keys

    return unless routing.key?(target_field_address_array)

    distance = {}
    prev = {}

    field_index.each do |field|
      distance[field] = infinity
      prev[field] = -1
    end

    distance[starting_field_address_array] = 0
    unvisited_nodes_queue = field_index.compact
    while unvisited_nodes_queue.size.positive?
      current_node = nil
      unvisited_nodes_queue.each do |node|
        current_node = node if !current_node || (distance[node] && distance[node] < distance[current_node])
      end
      break if distance[current_node] == infinity

      unvisited_nodes_queue -= [current_node]
      routing[current_node].each_key do |another_node|
        alternative_route = distance[current_node] + routing[current_node][another_node]
        if alternative_route < distance[another_node]
          distance[another_node] = alternative_route
          prev[another_node] = current_node
        end
      end
    end

    shortest_path = []
    distance = 0

    until target_field_address_array == starting_field_address_array
      shortest_path << target_field_address_array if prev[target_field_address_array] != -1
      distance += routing[prev[target_field_address_array]][target_field_address_array]
      target_field_address_array = prev[target_field_address_array]
    end
    shortest_path << target_field_address_array

    distance
  end

  def self.find_fields_within_attack_range(starting_field)

  end
end
