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

class Game
  attr_accessor :board, :players, :log

  def initialize(size_of_board, uniform: true)
    @board = Board.new(size_of_board, uniform: uniform)
    @log = BattleLog.new
    @players = []
  end

  def move(from_position, to_position)
    unless !check_field(to_position).obstacle && check_field(to_position).is_empty? && valid_position(from_position) && valid_position(to_position)
      raise InvalidMovementError
    end

    @log.move(check_field(from_position).occupant, to_position)
    check_field(from_position).occupant.move(to_position)
    check_field(to_position).update_occupant(check_field(from_position).occupant)
    check_field(from_position).update_occupant('')
  end

  def attack(from_position, to_position)
    raise InvalidTargetError unless check_field(to_position).is_occupied? && different_owners(
      from_position, to_position
    ) && valid_position(from_position) && valid_position(to_position)


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

  def place(owner: '', type: '', x: nil, y: nil, board_fields: nil)
    raise UnknownPlayerError unless @players.map { |player| player = player.name }.include?(owner)

    raise InvalidPositionError unless x <= @board.upper_limit && y <= @board.upper_limit && @board.state[x][y].is_empty? && @players.filter do |player|
                                        player.name == owner
                                      end.first.summoning_zone.include?([
                                                                          x, y
                                                                        ])

    summoned_minion = Minion.new(owner: owner, type: type, x: x, y: y, board: @board)
    minion_owner = @players.filter { |player| player.name == owner }.first
    raise InsufficientManaError unless minion_owner.mana >= summoned_minion.mana_cost

    minion_owner.manapool.spend(summoned_minion.mana_cost)
    minion_owner.add_minion(summoned_minion)

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

  def check_field(position)
    @board.check_field(position)
  end

  def valid_position(position)
    @board.valid_position(position)
  end

  def perish_a_creature(position)
    minion = check_field(position).occupant
    minion_owner = @players.filter { |player| player.name == check_field(position).occupant.owner }.first
    check_field(position).update_occupant('')
    minion_owner.minions.delete(minion)
  end

  # need to rewrite this for actual position objects
  def different_owners(first_occupant_position_array, second_occupant_position_array)
    check_field(first_occupant_position_array).occupant.owner != check_field(second_occupant_position_array).occupant.owner
  end
end
