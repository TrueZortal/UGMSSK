# frozen_string_literal: true

# Speed/range thresholds
# 1 -> 1 straight, 0 diagonal,
# 1.5 -> 1 straight, 1 diagonal,
# 2 -> 2 straight, 1 diagonal,
# 2.83 -> 2 straight, 2 diagonal
# 3 -> 3 straight, 2 across
# 4.25 -> 3 straight, 3 across

require_relative 'position'
require_relative 'pathfinding'

class InvalidMovementError < StandardError
end

class Minion
  # 🏹💀🐉

  @@THRESHOLDS = {
    1 => [1, 0],
    1.5 => [1, 1],
    2 => [2, 1],
    2.83 => [2, 2],
    3 => [3, 2],
    4.25 => [3, 3]
  }

  @@MINION_DATA = {
    'skeleton': { mana_cost: 1, symbol: 's', health: 5, attack: 1, defense: 0, speed: 2, initiative: 3, range: 1.5 },
    'skeleton archer': { mana_cost: 2, symbol: 'a', health: 2, attack: 2, defense: 0, speed: 1, initiative: 3,
                         range: 3 }
  }
  attr_accessor :attack, :defense, :health, :speed, :initiative, :range, :position
  attr_reader :mana_cost, :owner, :type, :current_health, :symbol, :fields_with_enemies_in_range

  def initialize(x: 0, y: 0, owner: '', type: 'skeleton', board: nil, minion_json: '', from_db: false, db_record:'')
    raise ArgumentError unless @@MINION_DATA.keys.include?(type.to_sym)

    @minion_json = minion_json
    # if minion_json != ''
    #   from_json
    #   @max_health = @@MINION_DATA[@type.to_sym][:health]
    if from_db
        @position = Position.new(db_record['x_position'],db_record['y_position'])
        @owner = db_record['owner']
        @health = db_record['health']
        @type = db_record['minion_type']
        @max_health = @@MINION_DATA[@type.to_sym][:health]
    else
      @position = Position.new(x, y)
      @owner = owner
      @type = type
      @max_health = @@MINION_DATA[@type.to_sym][:health]
      @health = @max_health
      save_state
    end
    @current_health = "#{@health}/#{@max_health}"
    @symbol = @@MINION_DATA[@type.to_sym][:symbol]
    @attack = @@MINION_DATA[@type.to_sym][:attack]
    @defense = @@MINION_DATA[@type.to_sym][:defense]
    @speed = @@MINION_DATA[@type.to_sym][:speed]
    @initiative = @@MINION_DATA[@type.to_sym][:initiative]
    @range = @@MINION_DATA[@type.to_sym][:range]
    @mana_cost = @@MINION_DATA[@type.to_sym][:mana_cost]
    #----- The below should most likely be removed to another class not be part of Minion class -----
    update_board(board)
  end

  def save_state
    minion_to_add = SummonedMinion.new(owner: @owner,minion_type: @type, health: @health, x_position: @position.x, y_position: @position.y)
    minion_to_add.save
  end

  def make_json
    minion_json = {
      position: @position.make_json,
      owner: @owner,
      type: @type,
      health: @health
    }
    JSON.generate(minion_json)
  end

  def from_json
    @minion_hash = JSON.parse(@minion_json)
    @position = Position.new(position_json: @minion_hash['position'])
    @owner = @minion_hash['owner']
    @type = @minion_hash['type']
    @health = @minion_hash['health']
    @type = @minion_hash['type']
  end

  #----- The below should most likely be removed to another class not be part of Minion class -----
  def update_board(board)
    @board = board
    @board_fields = board.nil? ? nil : board.array_of_fields
    find_and_update_fields_in_attack_range
    find_enemies_in_attack_range
    add_observers
  end

  def icon
    icon_dictionary = { 'skeleton' => '64x64Skelly.png', 'skeleton archer' => '64x64SkellyArcher.png' }
    icon_dictionary[@type]
  end

  def update(_position_object, _occupied)
    find_enemies_in_attack_range
  end

  def move(to_position)
    raise InvalidMovementError unless Pathfinding.new(@board.field_at(@position), @board.field_at(to_position),
                                                      @board.pathfinding_data).shortest_path_and_distance.values[0] <= @speed

    @position = to_position
    remove_observers
    find_and_update_fields_in_attack_range
    find_enemies_in_attack_range
    add_observers
  end

  def attack_action(another_minion)
    raise OutOfRangeError unless @position.distance(another_minion.position) <= @range

    target_defense = another_minion.defense

    # damage calculation is currently attack - defense but no less than 1
    damage = @attack - target_defense > 1 ? @attack - target_defense : 1

    another_minion.take_damage(damage)
    find_enemies_in_attack_range
    damage
  end

  def take_damage(damage)
    @health -= damage
    @current_health = "#{@health}/#{@max_health}"
  end

  def status
    { pos: @position.to_a, type: @type, hp: @current_health }
  end

  def quick_status
    "#{@type} - hp:#{@current_health} - #{@position.to_a}"
  end

  # This should not be implemented here
  def print_selectable_hash_of_available_targets
    generate_selectable_hash_of_available_targets
  end

  def can_attack
    !@fields_with_enemies_in_range.empty?
  end

  def find_db_entries_of_enemies_in_range
    @fields_with_enemies_in_range.map { |field| SummonedMinion.where(x_position: field.position.x, y_position: field.position.y)}.flatten
  end

  private

  def find_and_update_fields_in_attack_range
    @fields_in_attack_range = []
    @board_fields&.filter do |field|
      field.position != @position && @position.distance(field.position) <= @range
    end&.each do |field|
      @fields_in_attack_range << field
    end
    @fields_in_attack_range.uniq!
  end

  # This should not be implemented here
  def find_fields_between_self_and_target(field)
    array_of_bidrectional_route_coordinates = @position.get_valid_routes(field.position)
    biderctional_array_of_route_fields = []
    array_of_bidrectional_route_coordinates.each do |array_of_coordinates|
      biderctional_array_of_route_fields << @board_fields.filter do |route_field|
        array_of_coordinates.include?(route_field.position.to_a)
      end
    end
    biderctional_array_of_route_fields
  end

  # This should be only partially implemented here/call outside method for this
  def find_enemies_in_attack_range
    @fields_with_enemies_in_range = []
    @fields_in_attack_range.each do |field|
      @fields_with_enemies_in_range << field if field.occupied? && field.occupant.owner != @owner
    end
    unless fields_with_enemies_in_range.empty?
      check_if_interaction_with_field_is_not_blocked_by_obstacles(@fields_with_enemies_in_range)
    end
    @fields_with_enemies_in_range
  end


  # This should not be implemented here
  def check_if_interaction_with_field_is_not_blocked_by_obstacles(array_of_fields)
    array_of_fields.filter! do |field|
      find_fields_between_self_and_target(field).any? do |array_of_coordinates|
        array_of_coordinates.all? do |field_on_the_way_to_the_other_field|
          field_on_the_way_to_the_other_field.obstacle == false
        end
      end
    end
  end

  def add_observers
    @fields_in_attack_range.each do |field|
      field.add_observer(self)
    end
  end

  def remove_observers
    @fields_in_attack_range.each do |field|
      field.delete_observer(self)
    end
  end

  # This should not be implemented here
  def generate_selectable_hash_of_available_targets
    target_menu = {}
    @fields_with_enemies_in_range.each_with_index do |field, index|
      target_menu[index] = field.occupant.status
    end
    target_menu.each_pair do |id, status|
      puts "#{id} : #{status}"
    end
  end

  def puts(string)
    Output.new.print(string)
  end
end
