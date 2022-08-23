# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_08_23_192437) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "board_fields", force: :cascade do |t|
    t.integer "game_id"
    t.integer "x_position", null: false
    t.integer "y_position", null: false
    t.string "status"
    t.string "occupant_type"
    t.integer "occupant_id", null: false
    t.string "terrain", null: false
    t.boolean "obstacle", null: false
    t.string "offset", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "board_states", force: :cascade do |t|
    t.text "board"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "game_id"
  end

  create_table "event_logs", force: :cascade do |t|
    t.integer "game_id"
    t.string "event", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "minion_in_games", force: :cascade do |t|
    t.string "minion_type", null: false
    t.string "owner", null: false
    t.integer "x", null: false
    t.integer "y", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "minion_stats", force: :cascade do |t|
    t.integer "mana_cost", null: false
    t.integer "health", null: false
    t.integer "attack", null: false
    t.integer "defense", null: false
    t.integer "speed", null: false
    t.integer "initiative", null: false
    t.integer "range", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "minion_type"
    t.string "icon"
  end

  create_table "pvp_players", force: :cascade do |t|
    t.integer "game_id"
    t.string "name", null: false
    t.integer "mana", null: false
    t.integer "max_mana", null: false
    t.string "summoning_zone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "available_actions", default: [], array: true
  end

  create_table "summoned_minions", force: :cascade do |t|
    t.integer "owner_id"
    t.string "owner"
    t.string "minion_type", null: false
    t.integer "health", null: false
    t.integer "x_position", null: false
    t.integer "y_position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "can_attack", default: false
  end

  create_table "turn_trackers", force: :cascade do |t|
    t.integer "game_id"
    t.integer "turn_number"
    t.boolean "complete", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_id"
  end

end
