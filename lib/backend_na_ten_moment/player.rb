# frozen_string_literal: true

require_relative 'mana_pool'

class Player
  attr_reader :name, :id
  attr_accessor :manapool, :mana, :minions, :available_minions, :summoning_zone, :db_minions

  def initialize(name: '', mana: 0, summoning_zone: [], from_db: false, db_record: [])
    if from_db
      @id = db_record['id']
      @name = db_record['name']
      @manapool = ManaPool.new(mana: db_record['max_mana'])
      @manapool.mana = db_record['mana']
    else
      @name = name
      @manapool = ManaPool.new(mana: mana) # tu tu tururu
    end
    @mana = @manapool.mana
    @minions = []
    @db_minions = SummonedMinion.where owner: @name
    @summoning_zone = summoning_zone
    @available_minions = ['skeleton', 'skeleton archer']
  end

  def status
    status = "\nMana:#{manapool.current} \nCurrent Minions:#{minion_list}"
  end

  def minions?
    SummonedMinion.where('owner_id = ?', @id).empty?
  end

  def minions_who_can_attack?
    !SummonedMinion.where('owner_id = ? and can_attack = ?', @id, true).empty?
  end

  def mana?
    PvpPlayers.find(@id).mana.positive?
  end

  def available_options
    # there are minions and they can attack
    if !minions? && minions_who_can_attack?
      PvpPlayers.find(@id)['available_actions'] = %w[summon move attack concede pass]
    # the mana pool is empty
    elsif mana?
      PvpPlayers.find(@id)['available_actions'] = %w[move concede pass]
    # there are no minions
    elsif minions?
      PvpPlayers.find(@id)['available_actions'] = %w[summon concede pass]
    # there are minions
    elsif !minions?
      PvpPlayers.find(@id)['available_actions'] = %w[summon move concede pass]
    end
  end

  def add_minion(minion_instance)
    @mana = @manapool.mana
    @minions << minion_instance
    @db_minions = SummonedMinion.where owner: @name
  end

  def db_minions_who_can_attack
    array_of_records_of_minions_who_can_attack = []
    @minions.select(&:can_attack).each do |minion|
      array_of_records_of_minions_who_can_attack << SummonedMinion.where(x_position: minion.position.x,
                                                                         y_position: minion.position.y)
    end
    array_of_records_of_minions_who_can_attack.flatten
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

  def save(game_id: nil)
    player_save_state = PvpPlayers.new(game_id: game_id, name: @name, mana: @manapool.mana, max_mana: @manapool.max,
                                       summoning_zone: @summoning_zone.to_s)
    player_save_state.save
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
    @minions.each do |minion|
      p minion.status
    end
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
