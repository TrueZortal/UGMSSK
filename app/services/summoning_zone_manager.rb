# frozen_string_literal: true

module SummoningZoneManager
  class GrabAvailableSummoningZoneFromAGame < ApplicationService
    attr_reader :game_id, :player_id

    def initialize(game_id, player_id)
      @game_id = game_id
      @player_id = player_id
    end

    def call
      board_record = BoardState.find_by(game_id: game_id)
      available_zones = board_record.summoning_zones
      pulled_zone = available_zones.shuffle.shift
      available_zones.delete(pulled_zone)
      board_record.update(
        summoning_zones: available_zones
      )
      PvpPlayers.find(player_id).update(
        summoning_zone: pulled_zone
      )
    end
  end

  class ReturnSummoningZoneWhenLeavingOrRemoved < ApplicationService
    attr_reader :game_id, :player_id

    def initialize(game_id, player_id)
      @game_id = game_id
      @player_id = player_id
    end

    def call
      board_record = BoardState.find_by(game_id: game_id)
      zone_to_return = PvpPlayers.find(player_id).summoning_zone
      available_zones = board_record.summoning_zones
      available_zones << zone_to_return

      board_record.update(
        summoning_zones: available_zones
      )
    end
  end

  class TranslateZoneFromTextToArray < ApplicationService
    attr_reader :zone_string

    def initialize(zone_string)
      @zone_string = zone_string
    end

    def call
      zone_dictionary = {
        "top left": [[0, 0], [0, 1], [1, 0], [1, 1]],
        "top right": [[0, 6], [0, 7], [1, 6], [1, 7]],
        "bottom left": [[6, 0], [6, 1], [7, 0], [7, 1]],
        "bottom right": [[6, 6], [6, 7], [7, 6], [7, 7]]
      }
      zone_dictionary[zone_string.to_sym]
    end
  end
end
