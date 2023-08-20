class BoardFieldsController < ApplicationController
  def show
    # TODO: this can likely be removed
    @field = BoardField.find(params['id'])
  end

  # TODO: This can likely be removed
  def refresh_fields
    @field = BoardField.find(params['id'])
    @from_field = BoardField.find(params['from_field_id'])
    game_id = @field.game_id
    @game = Game.find(game_id)
    @current_player = TurnTracker.create_turn_or_pull_current_player_if_turn_exists(game_id: game_id)

    respond_to do |format|
      format.html
      format.turbo_stream
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
