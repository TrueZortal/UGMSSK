require 'rails_helper'

RSpec.describe "SummonedMinions", type: :request do
  describe "POST /update_drag" do
    context "works! (now write some real specs)" do
      subject {
        test_game = Game.new()
        test_game.save
        # p Game.all
        test_player = PvpPlayers.create(
          name: "test",
          mana: 10,
          max_mana: 10,
          summoning_zone: "top left",
          uuid: SecureRandom.uuid
        )
        test_minion = SummonedMinion.create(
          minion_type: 'skeleton',
          owner_id: test_player.id,
          owner: "test",
          health: 0,
          x_position: 0,
          y_position: 0,
          game_id: 1#test_game.id
        )
        test_field = BoardField.create(
          x_position: 0,
          y_position: 0,
          occupant_id: test_minion.id,
          occupant_type: test_minion.minion_type,
          terrain: 'grass',
          obstacle: false,
          offset:''
        )
        second_test_field = BoardField.create(
          x_position: 1,
          y_position: 1,
          terrain: 'grass',
          obstacle: false,
          offset:''
        )

        test_params = {
          "from_field_id"=>"#{test_field.id}",
          "to_field_id"=>"#{second_test_field.id}",
          "id"=>"#{test_field.id}",
          "summoned_minion"=>{}
        }
        puts "test inside subject"
        post("/summoned_minions/#{test_field.id}/update_drag/", :params => test_params)
      }
      it { is_expected.to match(200) }
    end
  end
end

# create_table "pvp_players", force: :cascade do |t|
#   t.integer "game_id"
#   t.string "name", null: false
#   t.integer "mana", null: false
#   t.integer "max_mana", null: false
#   t.string "summoning_zone", null: false
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   t.text "available_actions", default: [], array: true
#   t.string "color"
#   t.text "uuid", null: false
# end


# create_table "summoned_minions", force: :cascade do |t|
#   t.integer "owner_id"
#   t.string "owner"
#   t.string "minion_type", null: false
#   t.integer "health", null: false
#   t.integer "x_position", null: false
#   t.integer "y_position", null: false
#   t.datetime "created_at", null: false
#   t.datetime "updated_at", null: false
#   t.boolean "can_attack", default: false
#   t.integer "available_targets", default: [], array: true
#   t.integer "valid_moves", default: [], array: true
#   t.integer "game_id", null: false
# end