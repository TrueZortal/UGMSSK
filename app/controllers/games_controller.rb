# frozen_string_literal: true

class GamesController < ApplicationController
  def show
    if session[:current_user_uuid]
      @current_user = User.find_by(uuid: session[:current_user_uuid] )
    else
      redirect_to root_path
    end

    @game_instance = Game.new(game_id: game_params['id'].to_i)

    @game = if @game_instance.exists_and_is_underway
              @game_instance.continue
            elsif @game_instance.exists_but_is_waiting_to_start_or_to_finish
              @game_instance.wait_for_start_or_to_finish
            else
              sleep 30
              reset
            end

    if @game_instance.has_players
      @current_player = TurnTracker.pull_current_player_id(game_id: @game.id)
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  def start
    Game.start_game(game_id:game_params['id'].to_i)

    redirect_to "/games/#{game_params['id']}"
  end

  def reset
    game_id = game_params['id'].to_i
    Game.restart_new_on_existing_id(game_id: game_id)

    redirect_to root_url
  end

  private

  def game_params
    params.permit(:id, :format)
  end
end
