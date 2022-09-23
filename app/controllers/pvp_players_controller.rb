# frozen_string_literal: true

class PvpPlayersController < ActionController::Base
  def pass
    PvpPlayers.pass(player_id: player_params[:id].to_i)
    redirect_to "/games/#{PvpPlayers.find(player_params['id'].to_i).game_id}"
  end

  def concede
    PvpPlayers.concede(player_id: player_params[:id].to_i)
    redirect_to "/games/#{PvpPlayers.find(player_params['id'].to_i).game_id}"
  end

  def leave
    PvpPlayers.remove_player(player_id: player_params['id'].to_i)

    redirect_to root_path
  end

  def create
    game_id = player_params['game_id']

    player = PvpPlayers.new(
      name: params['name'],
      color: params['color'],
      mana: 10,
      max_mana: 10,
      summoning_zone:'',
      uuid: params['uuid'],
      game_id: game_id
    )
    player.save
    Game.add_player(game_id: game_id, player_id: player.id)
    current_user = User.find_by(uuid: params['uuid'])
    current_user.game_id = game_id
    current_user.save

    redirect_to "/games/#{game_id}"
  end

  def player_params
    params.permit(:id, :uuid, :color, :name, :game_id)
  end

end
