# frozen_string_literal: true

require_relative 'field'
require_relative 'minion'
require_relative 'board'
require_relative 'player'
require_relative 'battlelog'

class InvalidMovementError < StandardError
end

class OutOfRangeError < StandardError
end

class InvalidTargetError < StandardError
end

class UnknownPlayerError < StandardError
end

class DuplicatePlayerError < StandardError
end

class InsufficientManaError < StandardError
end

# An instance of game, contains basic gameplay logic
class Game
  attr_accessor :board, :players, :log

  def initialize(size_of_board, uniform: true, board_json: '')
    @board = if board_json != ''
               Board.new(size_of_board, uniform: uniform, board_json: board_json)
              else
                Board.new(size_of_board, uniform: uniform)
              end
    # reassign_minions_to_owners
    @log = Battlelog.new
    @players = []
  end

  def reassign_minions_to_owners
    @board.array_of_fields.each do |field|
      p field
      # owner = find_owner_object_from_name(field.occupant.owner_name)
      # update_owner_status_after_summoning(owner, field.occupant)
    end
  end

  def move(from_position, to_position)
    unless validate_target_field_position(to_position) && validate_positions(from_position,
                                                                             to_position)
      raise InvalidMovementError
    end

    @log.move(check_field(from_position).occupant, to_position)
    check_field(from_position).occupant.move(to_position)
    check_field(to_position).update_occupant(check_field(from_position).occupant)
    check_field(from_position).update_occupant('')
  end

  def attack(from_position, to_position)
    raise InvalidTargetError unless validate_target(from_position, to_position)

    attacker = check_field(from_position).occupant
    defender = check_field(to_position).occupant
    damage = attacker.attack_action(defender)
    @log.attack(attacker, defender, damage)
    perish_a_creature(to_position) if check_field(to_position).occupant.health <= 0
  end

  def concede(player)
    @log.concede(player)
    player.clear_minions(@board)
    player.manapool.empty
  end

  def add_player(player_name, max_mana: 0, summoning_zone: nil)
    raise DuplicatePlayerError unless @players.filter { |player| player.name == player_name }.empty?

    starting_zone = summoning_zone.nil? ? @board.grab_a_starting_summoning_zone : summoning_zone
    @players << Player.new(name: player_name, mana: max_mana, summoning_zone: starting_zone)
  end

  # returns summoned minion
  # rubocop:disable Naming Naming/MethodParameterName
  def place(owner: '', type: '', x: nil, y: nil)
    # rubocop:enable Naming Naming/MethodParameterName

    raise UnknownPlayerError unless validate_owner(owner)

    raise InvalidPositionError unless validate_coordinates(x, y) && validate_owner_summoning_zone(owner, x, y)

    summoned_minion = Minion.new(owner: owner, type: type, x: x, y: y, board: @board)
    minion_owner = find_owner_object_from_name(owner)
    raise InsufficientManaError unless validate_owner_sufficient_mana(minion_owner, summoned_minion)

    update_owner_status_after_summoning(minion_owner, summoned_minion)
    @log.place(summoned_minion, minion_owner.mana)
    @board.state[x][y].update_occupant(summoned_minion)
    summoned_minion
  end

  def there_can_be_only_one
    remaining_players.size == 1
  end

  def remaining_players
    (@players - @players.filter { |player| player.manapool.empty? && player.minions.empty? })
  end

  private

  def validate_target(from_position, to_position)
    check_field(to_position).occupied? && different_owners(from_position,
                                                           to_position) && validate_positions(from_position,
                                                                                              to_position)
  end

  def validate_target_field_position(field_position)
    !check_field(field_position).obstacle && check_field(field_position).empty?
  end

  def validate_coordinates(x_coordinate, y_coordinate)
    x_coordinate <= @board.upper_limit && y_coordinate <= @board.upper_limit &&
      @board.state[x_coordinate][y_coordinate].empty?
  end

  def validate_owner(owner_name)
    @players.map(&:name).include?(owner_name)
  end

  def validate_owner_summoning_zone(owner, x_coordinate, y_coordinate)
    find_owner_object_from_name(owner).summoning_zone.include?([x_coordinate, y_coordinate])
  end

  def validate_owner_sufficient_mana(minion_owner, summoned_minion)
    minion_owner.mana >= summoned_minion.mana_cost
  end

  def find_owner_object_from_name(owner_name)
    @players.filter { |player| player.name == owner_name }.first
  end

  def update_owner_status_after_summoning(minion_owner, summoned_minion)
    minion_owner.manapool.spend(summoned_minion.mana_cost)
    minion_owner.add_minion(summoned_minion)
  end

  def check_field(position)
    @board.check_field(position)
  end

  def valid_position(position)
    @board.valid_position(position)
  end

  def validate_positions(position, other_position)
    @board.valid_position(position) && @board.valid_position(other_position)
  end

  def perish_a_creature(position)
    minion = check_field(position).occupant
    minion_owner = @players.filter { |player| player.name == check_field(position).occupant.owner }.first
    check_field(position).update_occupant('')
    minion_owner.minions.delete(minion)
  end

  # need to rewrite this for actual position objects
  def different_owners(position, second_position)
    check_field(position).occupant.owner != check_field(second_position).occupant.owner
  end
end
