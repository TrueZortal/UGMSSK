# frozen_string_literal: true

class GamesController < ApplicationController
  def start
    if Game.all.empty?
      @game = Game.start_new
    else
      @game = Game.continue
    end
    # p @game
    @current_player = TurnTracker.pull_current_player_id(game_id: @game.id)
  end

  def reset
    BoardState.destroy_all
    BoardField.destroy_all
    PvpPlayers.destroy_all
    SummonedMinion.destroy_all
    EventLog.destroy_all
    TurnTracker.destroy_all
    Game.destroy_all

    redirect_to root_url
  end

  def start_game; end
end


