# frozen_string_literal: true

class PvpPlayersController < ActionController::Base
  def pass
    # p params
    PvpPlayers.pass(player_id: player_params[:id].to_i)
    redirect_to "/games/#{PvpPlayers.find(player_params['id'].to_i).game_id}"
  end

  def concede
    # p params
    PvpPlayers.concede(player_id: player_params[:id].to_i)
    redirect_to "/games/#{PvpPlayers.find(player_params['id'].to_i).game_id}"
  end

  def player_params
    params.permit(:id)
  end
end
