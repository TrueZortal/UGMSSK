# frozen_string_literal: true

class GamesController < ApplicationController
  def show
    if session[:current_user_uuid]
      @current_user = User.find_by(uuid: session[:current_user_uuid] )
    else
      redirect_to root_path
    end

    @potential_game = Game.new(game_id: game_params['id'].to_i)

    @game = if @potential_game.exists_and_is_underway
              @potential_game.continue
            elsif @potential_game.exists_but_is_waiting_to_start_or_to_finish
              @potential_game.wait_for_start_or_to_finish
            else
              reset
            end

    if !PvpPlayers.where(game_id: @potential_game.id).empty?
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
