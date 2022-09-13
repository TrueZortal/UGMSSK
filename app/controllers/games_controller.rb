# frozen_string_literal: true

class GamesController < ApplicationController
  def show
    if session[:current_user_uuid]
      @current_user = User.find_by(uuid: session[:current_user_uuid] )
    else
      redirect_to root_path
    end

    game_id = game_params['id'].to_i
    @game = if Game.exists?(id: game_id) && Game.find(game_id).underway
              Game.continue(game_id: game_id)
            elsif Game.exists?(id: game_id) && !PvpPlayers.where(game_id: game_id).empty? || Game.find(game_id).current_turn == 0 && !Game.find(game_id).underway
              Game.wait_for_start_or_to_finish(game_id: game_id)
            else
              reset
            end

    if !PvpPlayers.where(game_id: game_id).empty?
      @current_player = TurnTracker.pull_current_player_id(game_id: game_id)
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
    BoardState.where(game_id: game_id).destroy_all
    BoardField.where(game_id: game_id).destroy_all
    PvpPlayers.where(game_id: game_id).destroy_all
    SummonedMinion.where(game_id: game_id).destroy_all
    EventLog.where(game_id: game_id).destroy_all
    TurnTracker.where(game_id: game_id).destroy_all
    Game.restart_new_on_existing_id(game_id: game_id)
    User.where(game_id: game_id).each do |user|
      user.update(game_id: '')
    end
    redirect_to root_url
  end

  private

  def game_params
    params.permit(:id, :format)
  end
end
