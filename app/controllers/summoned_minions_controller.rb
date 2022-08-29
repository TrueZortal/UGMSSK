# frozen_string_literal: true

class SummonedMinionsController < ApplicationController
  # summon a minion
  # params: summoned minion -> owner_id, owner, minion_type, x_position, y_position
  def create
    p params
    p minion_params
    SummonedMinion.place(parameters: minion_params)
    redirect_to root_url
  end

  # move a minion
  # Parameters: {"authenticity_token"=>"[FILTERED]", "summoned_minion"=>{"owner_id"=>"56", "x_position"=>"3", "y_position"=>"2"}, "commit"=>"submit", "id"=>"18"}
  def update
    p params
    p minion_params
    SummonedMinion.move(parameters: minion_params)
    redirect_to root_url
  end

  # Parameters: {"authenticity_token"=>"[FILTERED]", "minion_type"=>"skeleton archer", "target_id"=>"18", "minion_target"=>"skeleton", "commit"=>"submit", "id"=>"17"}
  def update_attack
    p params
    p minion_params
    SummonedMinion.attack(parameters: minion_params)
    redirect_to root_url
  end

  def grab
    # p params

    minion = SummonedMinion.find(params['id'])
    # p minion
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
