# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SummonedMinions', type: :request do
  describe 'POST /create' do
    context 'A player with sufficient mana summons a minion to a valid field' do
      let(:test_game) { FactoryBot.create(:Game) }
      let(:test_player) { FactoryBot.create(:PvpPlayers, game_id: test_game.id) }
      let(:target_field) { FactoryBot.create(:BoardField, game_id: test_game.id, x_position: 1, y_position: 1) }
      let(:test_params) do
        {
          'summoned_minion' => {
            'game_id' => test_game.id,
            'owner_id' => test_player.id,
            'owner' => test_player.name,
            'minion_type' => 'skeleton',
            'position' => '[1, 1]'
          },
          'commit' => 'submit'
        }
      end
      subject do
        test_game.current_player_id = test_player.id
        test_game.save
        TurnTracker.create!(game_id: test_game.id, turn_number: test_game.current_turn, player_id: test_player.id)
        post('/summoned_minions/', params: test_params)
      end
      it { is_expected.to match(302) }

      it ', the field occupancy status and occupant id are expected to be updated to the newly summoned minion' do
        expect { subject }.to change {
          [target_field.reload.occupied, target_field.reload.occupant_type]
        }.from([false, '']).to([true, 'skeleton'])
      end
    end

    context 'A player with sufficient mana summons a minion to an already occupied field' do
      let(:test_game) { FactoryBot.create(:Game) }
      let(:test_player) { FactoryBot.create(:PvpPlayers, game_id: test_game.id) }
      let(:target_field) do
        FactoryBot.create(:BoardField, game_id: test_game.id, x_position: 1, y_position: 1, occupied: true, occupant_id: 666,
                                       occupant_type: 'tomato')
      end
      let(:test_params) do
        {
          'summoned_minion' => {
            'game_id' => test_game.id,
            'owner_id' => test_player.id,
            'owner' => test_player.name,
            'minion_type' => 'skeleton',
            'position' => '[1, 1]'
          },
          'commit' => 'submit'
        }
      end
      subject do
        test_game.current_player_id = test_player.id
        test_game.save
        TurnTracker.create!(game_id: test_game.id, turn_number: test_game.current_turn, player_id: test_player.id)

        post('/summoned_minions/', params: test_params)
      end
      it { is_expected.to match(302) }

      it ', the field occupancy status and occupant id are expected to be updated to the newly summoned minion' do
        expect { subject }.not_to change {
          [target_field.reload.occupied, target_field.reload.occupant_type, target_field.occupant_id]
        }
      end
    end
  end
  describe 'POST /update_drag' do
    context 'Minions owner is trying to drag his own minion to a valid movement field' do
      let(:test_game) { FactoryBot.create(:Game) }
      let(:test_player) { FactoryBot.create(:PvpPlayers, game_id: test_game.id) }
      let(:target_field) { FactoryBot.create(:BoardField, game_id: test_game.id, x_position: 1, y_position: 1) }
      let(:test_minion) do
        FactoryBot.create(:SummonedMinion, owner_id: test_player.id, owner: test_player.name, game_id: test_game.id,
                                           valid_moves: [target_field.id])
      end
      let(:test_field) do
        FactoryBot.create(:BoardField, game_id: test_game.id, occupied: true, occupant_id: test_minion.id,
                                       occupant_type: test_minion.minion_type)
      end

      let(:test_params) do
        {
          'from_field_id' => test_field.id.to_s,
          'to_field_id' => target_field.id.to_s,
          'id' => test_field.id.to_s,
          'summoned_minion' => {}
        }
      end
      subject do
        test_game.current_player_id = test_player.id
        test_game.save
        TurnTracker.create(game_id: test_game.id, turn_number: test_game.current_turn, player_id: test_player.id)
        FactoryBot.create(:BoardState, game_id: test_game.id)
        post("/summoned_minions/#{test_field.id}/update_drag/", params: test_params)
      end
      it { is_expected.to match(302) }

      it ',the minion moves to the new field' do
        expect { subject }.to change {
                                [test_minion.reload.x_position, test_minion.reload.y_position]
                              }.from([0, 0]).to([1, 1])
      end

      it ',both fields get updated to reflect the change in occupant' do
        expect { subject }.to change {
                                [test_field.reload.occupant_id, target_field.reload.occupant_id, test_field.reload.occupied,
                                 target_field.reload.occupied]
                              }.from([test_minion.id, nil, true, false]).to([nil, test_minion.id, false, true])
      end
    end

    context 'A player is trying to drag another players minion' do
      let(:test_game) { FactoryBot.create(:Game) }
      let(:test_player) { FactoryBot.create(:PvpPlayers, game_id: test_game.id) }
      let(:second_test_player) { FactoryBot.create(:PvpPlayers, game_id: test_game.id, name: 'test_test') }
      let(:target_field) { FactoryBot.create(:BoardField, game_id: test_game.id, x_position: 1, y_position: 1) }
      let(:test_minion) do
        FactoryBot.create(:SummonedMinion, owner_id: second_test_player.id, owner: test_player.name, game_id: test_game.id,
                                           valid_moves: [target_field.id])
      end
      let(:test_field) do
        FactoryBot.create(:BoardField, game_id: test_game.id, occupant_id: test_minion.id, occupant_type: 'skeleton')
      end

      let(:test_params) do
        {
          'from_field_id' => test_field.id.to_s,
          'to_field_id' => target_field.id.to_s,
          'id' => test_field.id.to_s,
          'summoned_minion' => {}
        }
      end
      subject do
        test_game.current_player_id = test_player.id
        test_game.save
        TurnTracker.create!(game_id: test_game.id, turn_number: test_game.current_turn, player_id: test_player.id)
        TurnTracker.create!(game_id: test_game.id, turn_number: test_game.current_turn,
                            player_id: second_test_player.id)
        FactoryBot.create(:BoardState, game_id: test_game.id)

        post("/summoned_minions/#{test_field.id}/update_drag/", params: test_params)
      end

      it 'raises a WrongPlayerError' do
        expect { subject }.to raise_error(WrongPlayerError)
      end
    end

    context 'A player is trying to move their minion to an invalid field' do
      let(:test_game) { FactoryBot.create(:Game) }
      let(:test_player) { FactoryBot.create(:PvpPlayers, game_id: test_game.id) }
      let(:target_field) { FactoryBot.create(:BoardField, game_id: test_game.id, x_position: 7, y_position: 7) }
      let(:test_minion) do
        FactoryBot.create(:SummonedMinion, owner_id: test_player.id, owner: test_player.name, game_id: test_game.id,
                                           valid_moves: [])
      end
      let(:test_field) do
        FactoryBot.create(:BoardField, game_id: test_game.id, occupant_id: test_minion.id,
                                       occupant_type: test_minion.minion_type)
      end

      let(:test_params) do
        {
          'from_field_id' => test_field.id.to_s,
          'to_field_id' => target_field.id.to_s,
          'id' => test_field.id.to_s,
          'summoned_minion' => {}
        }
      end
      subject do
        test_game.current_player_id = test_player.id
        test_game.save

        TurnTracker.create!(game_id: test_game.id, turn_number: test_game.current_turn, player_id: test_player.id)
        FactoryBot.create(:BoardState, game_id: test_game.id)

        post("/summoned_minions/#{test_field.id}/update_drag/", params: test_params)
      end

      it 'raises a InvalidMovementError' do
        expect { subject }.to raise_error(InvalidMovementError)
      end
    end

    context 'A player is dragging his minion to make a valid attack' do
      let(:test_game) { FactoryBot.create(:Game) }
      let(:test_player) { FactoryBot.create(:PvpPlayers, game_id: test_game.id) }
      let(:second_test_player) { FactoryBot.create(:PvpPlayers, game_id: test_game.id, name: 'test_test') }
      let(:target_minion) do
        FactoryBot.create(:SummonedMinion, owner_id: second_test_player.id, owner: second_test_player.name,
                                           game_id: test_game.id)
      end
      let(:target_field) do
        FactoryBot.create(:BoardField, game_id: test_game.id, x_position: 1, y_position: 1, occupied: true,
                                       occupant_id: target_minion.id, occupant_type: 'skeleton')
      end
      let(:test_minion) do
        FactoryBot.create(:SummonedMinion, owner_id: test_player.id, owner: test_player.name, game_id: test_game.id,
                                           can_attack: true, available_targets: [target_minion.id])
      end
      let(:test_field) do
        FactoryBot.create(:BoardField, game_id: test_game.id,
                                       occupant_id: test_minion.id, occupant_type: 'skeleton')
      end

      let(:test_params) do
        {
          'from_field_id' => test_field.id.to_s,
          'to_field_id' => target_field.id.to_s,
          'id' => test_field.id.to_s,
          'summoned_minion' => {}
        }
      end
      subject do
        test_game.current_player_id = test_player.id
        test_game.save
        MinionStat.create!([{
                             minion_type: 'skeleton archer', mana_cost: 2, health: 2, attack: 2, defense: 0, speed: 1, initiative: 3, range: 3, icon: '64x64SkellyArcher.png'
                           },
                            {
                              minion_type: 'skeleton', mana_cost: 1, health: 5, attack: 1, defense: 0, speed: 2, initiative: 3, range: 1.5, icon: '64x64Skelly.png'
                            }])

        TurnTracker.create!(game_id: test_game.id, turn_number: test_game.current_turn, player_id: test_player.id)
        TurnTracker.create!(game_id: test_game.id, turn_number: test_game.current_turn,
                            player_id: second_test_player.id)
        FactoryBot.create(:BoardState, game_id: test_game.id)

        post("/summoned_minions/#{test_field.id}/update_drag/", params: test_params)
      end

      it { is_expected.to match(302) }

      it ',the minion does not move' do
        expect { subject }.not_to change {
                                    [test_minion.reload.x_position, test_minion.reload.y_position]
                                  }
      end

      it ',the target receives damage' do
        expect { subject }.to change {
          target_minion.reload.health
        }.from(5).to(4)
      end

      it ',both fields stay unchanged' do
        expect { subject }.not_to change {
                                    [test_field.reload.occupant_id, target_field.reload.occupant_id, test_field.reload.occupied,
                                     target_field.reload.occupied]
                                  }
      end
    end
  end
end
