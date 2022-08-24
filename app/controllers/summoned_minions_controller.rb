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
    SummonedMinion.place(db_record: minion_to_summon)
    minion_to_summon.save
    redirect_to root_url
  end

  # move a minion
  def update
    # p params
    minion_params = params['summoned_minion']
    # puts  "MINION ID MINION ID#{params['id']} MINION ID MINION ID"
    minion = SummonedMinion.find params['id']
    SummonedMinion.move(minion_record: minion, params: minion_params)
    # p minion
    minion.update(
      x_position: minion_params['x_position'],
      y_position: minion_params['y_position']
    )
    redirect_to root_url
  end

  def update_attack
    minion_data = {
      'skeleton': { mana_cost: 1, symbol: 's', health: 5, attack: 1, defense: 0, speed: 2, initiative: 3, range: 1.5 },
      'skeleton archer': { mana_cost: 2, symbol: 'a', health: 2, attack: 2, defense: 0, speed: 1, initiative: 3,
                           range: 3 }
    }
    target = SummonedMinion.find params['target_id']
    health_after_damage = target['health'] - minion_data[params['minion_type'].to_sym][:attack]
    target.update(health: health_after_damage)
    redirect_to root_url
  end
end
