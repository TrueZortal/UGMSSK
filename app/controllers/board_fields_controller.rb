class BoardFieldsController < ApplicationController
  def show
    p params
    @field = BoardField.find(params['id'])
  end

  # TODO: data-turbo-stream="true" <= needs to be passed as param for this to work with a GET
  def refresh_fields
    @field = BoardField.find(params['id'])
    @from_field = BoardField.find(params['from_field_id'])
    game_id = @field.game_id
    @game = Game.find(game_id)
    @current_player = TurnTracker.create_turn_or_pull_current_player_if_turn_exists(game_id: game_id)

    respond_to do |format|
      format.html
      format.turbo_stream { broadcast_replace_to "fields",
        partial: "games/update",
        locals: { field: @field, game: @game, current_player: @current_player }
       }
    end
  end

  private

  def field_params
    params.permit(
      :id,
      :from_field_id,
      :to_field_id
    )
  end
end
