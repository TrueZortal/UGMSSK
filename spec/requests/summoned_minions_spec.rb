require 'rails_helper'

RSpec.describe "SummonedMinions", type: :request do
  describe "POST /update_drag" do
    context "Minions owner is trying to drag his own minion to a valid movement field" do
      let(:test_game) { FactoryBot.create(:Game) }
      let(:test_player) { FactoryBot.create(:PvpPlayers, game_id: test_game.id) }
      let(:target_field) { FactoryBot.create(:BoardField, game_id: test_game.id, x_position: 1, y_position: 1) }
      let(:test_minion) { FactoryBot.create(:SummonedMinion, owner_id: test_player.id, owner: test_player.name, game_id: test_game.id, valid_moves: [target_field.id])}
      let(:test_field) { FactoryBot.create(:BoardField, game_id: test_game.id, occupant_id: test_minion.id, occupant_type: 'skeleton') }

      let(:test_params) {
        {
          "from_field_id"=>"#{test_field.id}",
          "to_field_id"=>"#{target_field.id}",
          "id"=>"#{test_field.id}",
          "summoned_minion"=>{}
        }
      }
      subject {
        MinionStat.create!([{
          minion_type: 'skeleton archer', mana_cost: 2, health: 2, attack: 2, defense: 0, speed: 1, initiative: 3, range: 3, icon: '64x64SkellyArcher.png'
        },
         {
           minion_type: 'skeleton', mana_cost: 1, health: 5, attack: 1, defense: 0, speed: 2, initiative: 3, range: 1.5, icon: '64x64Skelly.png'
         }])

        TurnTracker.create(game_id: test_game.id, turn_number: test_game.current_turn, player_id: test_player.id)
        FactoryBot.create(:BoardState, game_id: test_game.id)

        post("/summoned_minions/#{test_field.id}/update_drag/", :params => test_params)
      }
      it { is_expected.to match(302) }
    end

    context "A player is trying to drag another players minion" do
      let(:test_game) { FactoryBot.create(:Game) }
      let(:test_player) { FactoryBot.create(:PvpPlayers, game_id: test_game.id) }
      let(:second_test_player) { FactoryBot.create(:PvpPlayers, game_id: test_game.id, name: "test_test") }
      let(:target_field) { FactoryBot.create(:BoardField, game_id: test_game.id, x_position: 1, y_position: 1) }
      let(:test_minion) { FactoryBot.create(:SummonedMinion, owner_id: second_test_player.id, owner: test_player.name, game_id: test_game.id, valid_moves: [target_field.id])}
      let(:test_field) { FactoryBot.create(:BoardField, game_id: test_game.id, occupant_id: test_minion.id, occupant_type: 'skeleton') }

      let(:test_params) {
        {
          "from_field_id"=>"#{test_field.id}",
          "to_field_id"=>"#{target_field.id}",
          "id"=>"#{test_field.id}",
          "summoned_minion"=>{}
        }
      }
      subject {
        MinionStat.create!([{
          minion_type: 'skeleton archer', mana_cost: 2, health: 2, attack: 2, defense: 0, speed: 1, initiative: 3, range: 3, icon: '64x64SkellyArcher.png'
        },
         {
           minion_type: 'skeleton', mana_cost: 1, health: 5, attack: 1, defense: 0, speed: 2, initiative: 3, range: 1.5, icon: '64x64Skelly.png'
         }])

        TurnTracker.create!(game_id: test_game.id, turn_number: test_game.current_turn, player_id: test_player.id)
        TurnTracker.create!(game_id: test_game.id, turn_number: test_game.current_turn, player_id: second_test_player.id)
        FactoryBot.create(:BoardState, game_id: test_game.id)

        post("/summoned_minions/#{test_field.id}/update_drag/", :params => test_params)
      }

      it "raises a WrongPlayerError" do
         expect { subject }.to raise_error(WrongPlayerError)
      end
    end
  end
end
