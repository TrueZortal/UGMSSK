# frozen_string_literal: true

class ExistingGame
  attr_reader :record_id

  def initialize(attributes = nil)
    @record_id = attributes.delete(:game_id) if attributes
    @game = Game.find(@record_id)
  end

  def exists_and_is_underway
    @game.underway
  end

  def exists_but_is_waiting_to_start
    !has_players || @game.current_turn.zero? && !@game.underway
  end

  def exists_but_is_waiting_to_finish
    has_players && !@game.underway && @game.current_turn != 0
  end

  def has_players
    !PvpPlayers.where(game_id: @record_id).empty?
  end

  def wait_for_start_or_to_finish
    @game
  end

  def continue
    @game
  end
end
