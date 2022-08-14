# frozen_string_literal: true

# logs all game events in an array
class Battlelog
  attr_accessor :log, :time

  def initialize
    @time = Time.now
    @log = []
  end

  def add(log_event)
    @log << log_event
  end

  def place(unit, mana_after_placing)
    remaining_mana = "they have #{mana_after_placing} mana remaining."
    event = "#{unit.owner} placed #{unit.type} on #{unit.position.to_a} for #{unit.mana_cost} mana, #{remaining_mana}"
    add(event)
  end

  def move(unit, to_position)
    event = "#{unit.owner} moved #{unit.type} from #{unit.position.to_a} to #{to_position.to_a}"
    add(event)
  end

  def attack(unit, another_unit, damage)
    message = another_unit.health.positive? ? "has #{another_unit.current_health} health" : 'perished'
    who_attacked_who = "#{unit.owner} attacked #{another_unit.owner}s #{another_unit.type} with their #{unit.type}"
    from_to_position = "from #{unit.position.to_a} to #{another_unit.position.to_a}"
    attacked_unit_status = "#{another_unit.owner}s #{another_unit.type} #{message}"
    event = " #{who_attacked_who} #{from_to_position} causing #{damage} damage. #{attacked_unit_status}"
    add(event)
  end

  def concede(player)
    minion_list = player.minions.map(&:status).join("\n")
    event = "#{player.name} has conceded, their minions #{minion_list} all perished"
    add(event)
  end

  def print
    output = String.new("**#{@time.utc} Battlelog**\n", encoding: 'UTF-8')
    @log.each_with_index do |event, index|
      output << "MOVE #{index + 1}:#{event}\n"
    end
    output << '------------'
    output
  end
end
