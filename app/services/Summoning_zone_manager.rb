module SummoningZoneManager
  class GrabAvailableSummoningZoneFromAGame < ApplicationService
    attr_reader :game_id, :player_id

    def initialize(game_id,player_id)
      @game_id = game_id
      @player_id = player_id
    end

    def call
      board_record = BoardState.find_by(game_id: @game_id)
      available_zones = board_record.summoning_zones
      pulled_zone = available_zones.shuffle.shift
      available_zones.delete(pulled_zone)
      board_record.update(
        summoning_zones: available_zones
      )
      PvpPlayers.find(@player_id).update(
        summoning_zone: pulled_zone
      )
    end
  end

  class ReturnSummoningZoneWhenLeavingOrRemoved < ApplicationService
    attr_reader :game_id, :player_id

    def initialize(game_id,player_id)
      @game_id = game_id
      @player_id = player_id
    end

    def call
      p @game_id
      board_record = BoardState.find_by(game_id: @game_id)
      p board_record
      zone_to_return = PvpPlayers.find(@player_id).summoning_zone
      available_zones = board_record.summoning_zones
      available_zones << zone_to_return

      board_record.update(
        summoning_zones: available_zones
      )
    end
  end
end