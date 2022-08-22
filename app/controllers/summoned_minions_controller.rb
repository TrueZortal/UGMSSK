# frozen_string_literal: true

class SummonedMinionsController < ApplicationController
  def create
    minion_data = {
      'skeleton': { mana_cost: 1, symbol: 's', health: 5, attack: 1, defense: 0, speed: 2, initiative: 3, range: 1.5 },
      'skeleton archer': { mana_cost: 2, symbol: 'a', health: 2, attack: 2, defense: 0, speed: 1, initiative: 3,
                           range: 3 }
    }
    minion_params = params['summoned_minion']
    # p minion_data[minion_params['minion_type']][:health]
    minion_to_summon = SummonedMinion.new(
      owner: minion_params['owner'],
      minion_type: minion_params['minion_type'],
      health: 2,
      x_position: minion_params['x_position'],
      y_position: minion_params['y_position']
    )
    minion_to_summon.save
    redirect_to root_url
  end

  def update
    p params
    minion_params = params['summoned_minion']
    # puts  "MINION ID MINION ID#{params['id']} MINION ID MINION ID"
    minion = SummonedMinion.find params['id']
    # p minion
    minion.update(
      x_position: minion_params['x_position'],
      y_position: minion_params['y_position']
    )
    redirect_to root_url
  end
end
