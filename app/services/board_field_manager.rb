# frozen_string_literal: true

module BoardFieldManager
  class ClearFieldByOccupant < ApplicationService
    attr_reader :occupant

    def initialize(occupant)
      @occupant = occupant
    end

    def call
      BoardField.find_by(occupant_id: occupant.id).update(
        occupant_id: nil,
        occupant_type: '',
        occupied: false
      )
    end
  end

  class UpdateFieldOccupant < ApplicationService
    attr_reader :field, :occupant

    def initialize(field, occupant)
      @field = field
      @occupant = occupant
    end

    def call
      field.update(
        occupant_id: occupant.id,
        occupant_type: occupant.minion_type,
        occupied: true
      )
    end
  end
end
