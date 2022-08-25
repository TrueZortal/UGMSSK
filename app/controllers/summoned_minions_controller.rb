# frozen_string_literal: true

class SummonedMinionsController < ApplicationController
  # summon a minion
  # params: summoned minion -> owner_id, owner, minion_type, x_position, y_position
  def create
    minion_params = params['summoned_minion']
    minion_type = minion_params['minion_type']
    minion_to_summon = SummonedMinion.new(
      owner: minion_params['owner'],
      owner_id: minion_params['owner_id'],
      minion_type: minion_params['minion_type'],
      health: MinionStat.find_by(minion_type: minion_type).health,
      x_position: minion_params['x_position'],
      y_position: minion_params['y_position']
    )
    minion_to_summon.save
    SummonedMinion.place(db_record: minion_to_summon)
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
end
