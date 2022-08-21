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

ActiveRecord::Schema[7.0].define(version: 2022_08_21_092905) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "board_states", force: :cascade do |t|
    t.text "board"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_logs", force: :cascade do |t|
    t.integer "game_id"
    t.string "event", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pvp_players", force: :cascade do |t|
    t.integer "game_id"
    t.string "name", null: false
    t.integer "mana", null: false
    t.integer "max_mana", null: false
    t.string "summoning_zone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  end

end
