# frozen_string_literal: true

require_relative 'manapool'

class Player
  attr_reader :name
  attr_accessor :manapool, :mana, :minions, :available_minions, :summoning_zone

  def initialize(name: '', mana: 0, summoning_zone: [])
    @name = name
    @manapool = ManaPool.new(mana: mana) # tu tu tururu
    @mana = @manapool.mana
    @minions = []
    @available_minions = ['skeleton', 'skeleton archer']
    @summoning_zone = summoning_zone
  end

  def status
    status = "\nMana:#{manapool.current} \nCurrent Minions:#{minion_list}"
  end

  def add_minion(minion_instance)
    @mana = @manapool.mana
    @minions << minion_instance
  end

  def print_selectable_hash_of_unliving_minions
    @minion_menu = {}
    @minions.each_with_index do |minion, index|
      @minion_menu[index] = minion.status
    end
    @minion_menu.each_pair do |id, status|
      puts "#{id} : #{status}"
    end
  end

  def print_selectable_hash_of_unliving_minions_who_can_attack
    @minion_menu = {}
    @minions.each_with_index do |minion, index|
      @minion_menu[index] = minion.status if minion.can_attack
    end
    @minion_menu.each_pair do |id, status|
      puts "#{id} : #{status}"
    end
  end

  def clear_minions(board)
    @minions.each do |minion|
      board.check_field(minion.position).update_occupant('')
      minion = nil
    end
    @minions = []
  end

  def get_position_from_minion_number(minion_number)
    @minions[minion_number].position
  end

  def get_minion_from_minion_number(minion_number)
    @minions[minion_number]
  end

  private

  def minion_list
    newline_list = +''
    if @minions.empty?
      newline_list = ' none'
    else
      @minions.each do |minion|
        newline_list << "\n#{minion.type} - hp:#{minion.current_health} - #{minion.position.to_a}"
      end
    end
    newline_list
  end

  def puts(string)
    Output.new.print(string)
  end
end
