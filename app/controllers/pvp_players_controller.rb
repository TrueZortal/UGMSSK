# frozen_string_literal: true

class PvpPlayersController < ActionController::Base
  def pass
    # p params
    PvpPlayers.pass(player_id: params['id'].to_i)
    redirect_to root_path
  end

  def concede
    # p params
    PvpPlayers.concede(player_id: params['id'].to_i)
    redirect_to root_path
  end
end