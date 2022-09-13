# frozen_string_literal: true

class SummonedMinionsController < ApplicationController
  # summon a minion
  # params: summoned minion -> owner_id, owner, minion_type, x_position, y_position
  def create
    SummonedMinion.place(parameters: minion_params)
    redirect_to "/games/#{minion_params['summoned_minion']['game_id']}"
  end

  def grab
    minion = SummonedMinion.find(params['id'])
    render json: minion
  end

  private

  def minion_params
    params.permit(
      :id,
      :authenticity_token,
      :commit,
      :x_position,
      :y_position,
      :summoned_minion => {}
    )
  end
end
