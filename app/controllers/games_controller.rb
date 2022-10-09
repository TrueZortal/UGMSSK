# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :restrict_access, :set_game_instance

  def show
  end

  def start
    Game.start_game(game_id: game_params['id'].to_i)

    redirect_to "/games/#{game_params['id']}"
  end

  def reset
    game_id = game_params['id'].to_i
    GameManager::RestartGameWithAnExistingGameID.call(game_id)

    redirect_to root_url
  end

  private

  def set_game_instance
    @game_instance = ExistingGame.new(game_id: game_params['id'].to_i)

    @game = if @game_instance.exists_and_is_underway
      @current_player = TurnTracker.create_turn_or_pull_current_player_if_turn_exists(game_id: @game_instance.record_id)
      @game_instance.continue
    elsif @game_instance.exists_but_is_waiting_to_start
      @game_instance.wait_for_start_or_to_finish
    elsif @game_instance.exists_but_is_waiting_to_finish
      @game_instance.wait_for_start_or_to_finish
    else
      reset
    end
  end

  def game_params
    params.permit(:id, :format)
  end
end
