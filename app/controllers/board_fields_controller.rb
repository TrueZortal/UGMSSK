# frozen_string_literal: true

class BoardFieldsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def update_drag
    # p headers
    # p params
    from_field_id = board_field_params['from_field_id'].to_i
    to_field_id = board_field_params['to_field_id'].to_i
    from_field = BoardField.find(from_field_id)
    to_field = BoardField.find(to_field_id)
    if to_field.occupied && !to_field.obstacle
      pseudo_params = {
        'id' => from_field.occupant_id,
        'target_id' => to_field.occupant_id
      }
      SummonedMinion.attack(parameters: pseudo_params)
    else
      pseudo_params = {
        'id' => from_field.occupant_id,
        'summoned_minion' => {
          'x_position' => to_field.x_position,
          'y_position' => to_field.y_position
        }
      }
      SummonedMinion.move(parameters: pseudo_params)
    end

    redirect_to "/games/#{PvpPlayers.find(player_params['id'].to_i).game_id}"
  end

  private

  def board_field_params
    params.permit(
      :from_field_id,
      :to_field_id,
      :id,
      :board_field => {}
    )
  end
end

# move
# Parameters: {"authenticity_token"=>"[FILTERED]", "summoned_minion"=>{"owner_id"=>"56", "x_position"=>"3", "y_position"=>"2"}, "commit"=>"submit", "id"=>"18"}
# attack
# Parameters: {"authenticity_token"=>"[FILTERED]", "minion_type"=>"skeleton archer", "target_id"=>"18", "minion_target"=>"skeleton", "commit"=>"submit", "id"=>"17"}
