module FinderManager
  class FindMinionsByOwner < ApplicationService
    attr_reader :owner_id

    def initialize(owner_id)
      @owner_id = owner_id
    end

    def call
      SummonedMinion.where('owner_id = ?', @owner_id)
    end

  end

  class FindBoardFieldByOccupantId < ApplicationService
    attr_reader :occupant_id

    def initialize(occupant_id)
      @occupant_id = occupant_id
    end

    def call
      BoardField.find_by(occupant_id: @occupant_id)
    end
  end

  class FindGameIdByPlayerId < ApplicationService
    attr_reader :pvp_player_id

    def initialize(pvp_player_id)
      @pvp_player_id = pvp_player_id
    end

    def call
      PvpPlayers.find(@pvp_player_id).game_id
    end
  end

end