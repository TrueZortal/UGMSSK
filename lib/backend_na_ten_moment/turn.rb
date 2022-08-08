# frozen_string_literal: true

require_relative 'position'
require_relative 'input'

class Turn
  def initialize(game_instance, turn_order)
    @game_instance = game_instance
    @order = turn_order
    play_turn
  end

  private

  def play_turn
    @order.each do |player|
      next if player.minions.empty? && player.manapool.empty?
      next if @game_instance.there_can_be_only_one

      puts "it's #{player.name}s move. #{player.status}"
      turn_if_tree(player)
    end
  end

  def turn_if_tree(player)
    if !player.minions.empty? && player.minions.any?(&:can_attack)
      actions_if_player_has_minions_with_available_targets(player)
    elsif player.manapool.empty?
      actions_if_player_has_no_mana_available(player)
    elsif player.minions.empty?
      actions_if_player_has_no_minions(player)
    elsif !player.minions.empty?
      actions_if_player_has_minions_available(player)
    end
  end

  def actions_if_player_has_no_minions(player_instance_of_current_player)
    puts "type your prefered action:\n'summon' a minion\n'concede'"
    ans = Input.get
    case ans
    when 'summon'
      summon(player_instance_of_current_player)
    when 'concede'
      concede(player_instance_of_current_player)
    else
      puts 'nothing selected, please enter a valid command'
      actions_if_player_has_no_minions(player_instance_of_current_player)
    end
  end

  def actions_if_player_has_no_mana_available(player_instance_of_current_player)
    puts "type your prefered action:\n'move' from a field to a field\n'attack' from a field to a field\n'concede'"
    ans = Input.get
    case ans
    when 'move'
      move(player_instance_of_current_player)
    when 'concede'
      concede(player_instance_of_current_player)
    else
      puts 'nothing selected, please enter a valid command'
      actions_if_player_has_no_mana_available(player_instance_of_current_player)
    end
  end

  def actions_if_player_has_minions_available(player_instance_of_current_player)
    puts "type your prefered action:\n'summon' a minion\n'move' from a field to a field\n'concede'"
    ans = Input.get
    case ans
    when 'summon'
      summon(player_instance_of_current_player)
    when 'move'
      move(player_instance_of_current_player)
    when 'concede'
      concede(player_instance_of_current_player)
    else
      puts 'nothing selected, please enter a valid command'
      actions_if_player_has_minions_available(player_instance_of_current_player)
    end
  end

  def actions_if_player_has_minions_with_available_targets(player_instance_of_current_player)
    puts "type your prefered action:\n'summon' a minion\n'move' from a field to a field\n'attack' from a field to a field\n'concede'"
    ans = Input.get
    case ans
    when 'summon'
      summon(player_instance_of_current_player)
    when 'move'
      move(player_instance_of_current_player)
    when 'attack'
      attack(player_instance_of_current_player)
    when 'concede'
      concede(player_instance_of_current_player)
    else
      puts 'nothing selected, please enter a valid command'
      actions_if_player_has_minions_available(player_instance_of_current_player)
    end
  end

  def summon(player_instance_of_current_player)
    puts "which minion do you want to summon? available: #{player_instance_of_current_player.available_minions}\n#{@game_instance.board.zone_message(player_instance_of_current_player.summoning_zone)}"
    minion = Input.get
    puts "which field do you want to place your minion? format 'x,y'"
    field = Input.get_position
    @game_instance.place(owner: player_instance_of_current_player.name, type: minion, x: field[0].to_i,
                         y: field[1].to_i)
    print_last_log_message
    show_boardstate
  rescue StandardError
    turn_if_tree(player_instance_of_current_player)
  end

  def attack(player_instance_of_current_player)
    puts 'which minion would you like to attack with? enter minion number to proceed'
    player_instance_of_current_player.print_selectable_hash_of_unliving_minions_who_can_attack
    minion_number = Input.get.to_i
    from_field = player_instance_of_current_player.get_position_from_minion_number(minion_number)
    puts 'which target would you like to attack?'
    player_instance_of_current_player.get_minion_from_minion_number(minion_number).print_selectable_hash_of_available_targets
    target_number = Input.get.to_i
    to_field = player_instance_of_current_player.get_minion_from_minion_number(minion_number).fields_with_enemies_in_range[target_number].position
    @game_instance.attack(from_field, to_field)
    print_last_log_message
    show_boardstate
  rescue StandardError
    puts 'invalid move!'
    actions_if_player_has_minions_available(player_instance_of_current_player)
  end

  def move(player_instance_of_current_player)
    puts 'which minion would you like to move with? enter minion number to proceed'
    player_instance_of_current_player.print_selectable_hash_of_unliving_minions
    minion_number = Input.get.to_i
    from_field = player_instance_of_current_player.get_position_from_minion_number(minion_number)
    puts "which field do you want to move to? format 'x,y'"
    to = Input.get_position
    to_field = Position.new(to[0].to_i, to[1].to_i)
    @game_instance.move(from_field, to_field)
    print_last_log_message
    show_boardstate
  rescue StandardError
    puts 'invalid move!'
    actions_if_player_has_minions_available(player_instance_of_current_player)
  end

  def concede(player_instance_of_current_player)
    @game_instance.concede(player_instance_of_current_player)
    print_last_log_message
    show_boardstate
  end

  def print_last_log_message
    puts @game_instance.log.log.last
  end

  def show_boardstate
    puts @game_instance.board.render_board
  end

  def puts(string)
    Output.new.print(string)
  end
end
