module JanitorManager
  class ClearFieldByOccupantID < ApplicationService
    attr_reader :occupant_id

    def initialize(occupant_id)
      @occupant_id = occupant_id
    end

    def call
      BoardField.find_by(occupant_id: occupant_id).update(
        occupant_id: nil,
        occupant_type: '',
        occupied: false
      )
    end

  end
end