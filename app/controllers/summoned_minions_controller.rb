# frozen_string_literal: true

class SummonedMinionsController < ApplicationController
  # summon a minion
  # params: summoned minion -> owner_id, owner, minion_type, x_position, y_position
  def create
    SummonedMinion.place(parameters: params)

    redirect_to root_url
  end

  # move a minion
  def update
    SummonedMinion.move(parameters: params)

    redirect_to root_url
  end

  def update_attack
    SummonedMinion.attack(parameters: params)

    redirect_to root_url
  end

  def grab
    # p params

    minion = SummonedMinion.find(params['id'])
    # p minion
    render json: minion
  end
end
