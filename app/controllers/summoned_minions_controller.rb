# frozen_string_literal: true

class SummonedMinionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    SummonedMinion.place(parameters: minion_params)
    redirect_to "/games/#{minion_params['summoned_minion']['game_id']}"
  end

  def grab
    minion = SummonedMinion.find(params['id'])
    render json: minion
  end

  def update_drag
    from_field_id = minion_params['from_field_id'].to_i
    to_field_id = minion_params['to_field_id'].to_i
    from_field = BoardField.find(from_field_id)
    to_field = BoardField.find(to_field_id)
    SummonedMinion.update_drag(from_field, to_field)

    redirect_to controller: :board_fields, action: :update, format: :turbo_stream, params: minion_params
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
