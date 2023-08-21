class UserDataController < ApplicationController
  def index
    @current_user = current_user
    @current_user_id =current_user.id
    @current_user_name = @current_user.name
    @game = Game.find(PvpPlayers.find_by(uuid: @current_user.uuid).game_id)
    @current_player = TurnTracker.create_turn_or_pull_current_player_if_turn_exists(game_id: @game.id)

    render turbo_stream: turbo_stream.replace(
      "#{@game.id}_controlblock",
      partial: 'games/game_control_menu',
      locals: {
        current_user_id: @current_user_id,
        current_user_name: @current_user_name,
        game: @game,
        current_player: @current_player
      }
    )
  end
end
