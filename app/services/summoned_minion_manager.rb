# frozen_string_literal: true

module SummonedMinionManager
  # Finds minion speed
  class FindMinionSpeedFromMinionRecord < ApplicationService
    attr_reader :minion_record

    def initialize(minion_record)
      super()
      @minion_record = minion_record
    end

    def call
      MinionStat.find_by(minion_type: minion_record.minion_type).speed
    end
  end

  # Finds minion health
  class FindMinionHealthFromMinionRecord < ApplicationService
    attr_reader :minion_record

    def initialize(minion_record)
      super()
      @minion_record = minion_record
    end

    def call
      MinionStat.find_by(minion_type: minion_record.minion_type).health
    end
  end

  # Finds minion cost
  class FindMinionManaFromMinionRecord < ApplicationService
    attr_reader :minion_record

    def initialize(minion_record)
      super()
      @minion_record = minion_record
    end

    def call
      MinionStat.find_by(minion_type: minion_record.minion_type).mana_cost
    end
  end

  # Finds minion range
  class FindMinionRangeFromMinionType < ApplicationService
    attr_reader :minion_type

    def initialize(minion_type)
      super()
      @minion_type = minion_type
    end

    def call
      MinionStat.find_by(minion_type: minion_type).range
    end
  end

  # Finds minion statistics
  class FindMinionStatsFromMinionID < ApplicationService
    attr_reader :minion_id

    def initialize(minion_id)
      super()
      @minion_id = minion_id
    end

    def call
      minion_type = SummonedMinion.find(minion_id).minion_type
      MinionStat.find_by(minion_type: minion_type)
    end
  end

  # Calculates damage
  class CalculateDamage < ApplicationService
    attr_reader :target, :minion

    def initialize(minion, target)
      super()
      @minion = minion
      @target = target
    end

    def call
      damage = MinionStat.find_by(minion_type: minion.minion_type).attack - MinionStat.find_by(minion_type: target.minion_type).defense
      damage = 1 if damage.negative?
      damage
    end
  end

  # Updates minion position
  class UpdateMinionsPositionFromTargetField < ApplicationService
    attr_reader :minion, :target_field

    def initialize(minion, target_field)
      super()
      @minion = minion
      @target_field = target_field
    end

    def call
      minion.update(
        x_position: target_field.x_position,
        y_position: target_field.y_position
      )
    end
  end

  # Transforms a position into a hash
  class TransformPositionIntoXYHash < ApplicationService
    attr_reader :position

    def initialize(position)
      super()
      @position = position
    end

    def call
      pos_array = position.split(/,/).map { |pos| pos[/\d/].to_i }
      {
        x_position: pos_array[0],
        y_position: pos_array[1]
      }
    end
  end

  # Finds all of a owners minions
  class FindMinionsByOwner < ApplicationService
    attr_reader :owner_id

    def initialize(owner_id)
      super()
      @owner_id = owner_id
    end

    def call
      SummonedMinion.where('owner_id = ?', owner_id)
    end
  end
end
