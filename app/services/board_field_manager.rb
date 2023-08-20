# frozen_string_literal: true

module BoardFieldManager
  # Removes occupant from field
  class ClearFieldByOccupant < ApplicationService
    attr_reader :occupant

    def initialize(occupant)
      super()
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

  # Adds occupant to field
  class UpdateFieldOccupant < ApplicationService
    attr_reader :field, :occupant

    def initialize(field, occupant)
      super()
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
