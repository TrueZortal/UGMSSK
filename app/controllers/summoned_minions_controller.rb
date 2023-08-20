# frozen_string_literal: true

class SummonedMinionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    position = SummonedMinionManager::TransformPositionIntoXYHash.call(minion_params['summoned_minion']['position'])
    game_id = minion_params['summoned_minion']['game_id']
    @field = BoardField.find_by(game_id: game_id,x_position: position[:x_position], y_position: position[:y_position])
    @game = Game.find(game_id)
    @current_player = TurnTracker.create_turn_or_pull_current_player_if_turn_exists(game_id: game_id)

    SummonedMinion.place(parameters: minion_params)

    @field.reload

    respond_to do |format|
      format.turbo_stream {
      # render "games/update_summon"
      Turbo::StreamsChannel.broadcast_replace_to(
        "board_fields",
        target: "#{@field.id}",
        partial: "games/field",
        locals: {
          field: @field,
          game: @game,
          current_player: @current_player
        }
      )


      }
      format.html { redirect_to "/games/#{minion_params['summoned_minion']['game_id']}" }
    end
  end

  def grab
    minion = SummonedMinion.find(params['id'])
    render json: minion
  end

  #TODO: Verify between Action Cable and Websocket as ACTION CABLE broadcasts a working update but only to the/of the ORIGINATING FIELD
  def update_drag
    from_field_id = minion_params['from_field_id'].to_i
    to_field_id = minion_params['to_field_id'].to_i
    from_field = BoardField.find(from_field_id)
    to_field = BoardField.find(to_field_id)
    SummonedMinion.update_drag(from_field, to_field)

    redirect_to game_path(BoardField.find(from_field_id).game_id, format: :html)
    # @field = to_field
    # @from_field = from_field
    # game_id = to_field.game_id
    # @game = Game.find(game_id)
    # @current_player = TurnTracker.create_turn_or_pull_current_player_if_turn_exists(game_id: game_id)

    # respond_to do |format|
    #   format.turbo_stream
    #   format.json
    # end
    # redirect_to controller: :board_fields, action: :refresh_fields, format: :turbo_stream, params: minion_params
  end

  private

  def minion_params
    params.permit(
      :id,
      :authenticity_token,
      :commit,
      :x_position,
      :y_position,
      :from_field_id,
      :to_field_id,
      board_field: {},
      summoned_minion: {}
    )
  end
end
