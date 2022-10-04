module SummonedMinionManager
  #Minion record finders
  class FindMinionSpeedFromMinionRecord < ApplicationService
    attr_reader :minion_record

    def initialize(minion_record)
      @minion_record = minion_record
    end

    def call
      MinionStat.find_by(minion_type: minion_record.minion_type).speed
    end
  end

  class FindMinionHealthFromMinionRecord < ApplicationService
    attr_reader :minion_record

    def initialize(minion_record)
      @minion_record = minion_record
    end

    def call
      MinionStat.find_by(minion_type: minion_record.minion_type).health
    end
  end

  class FindMinionManaFromMinionRecord < ApplicationService
    attr_reader :minion_record

    def initialize(minion_record)
      @minion_record = minion_record
    end

    def call
      MinionStat.find_by(minion_type: minion_record.minion_type).mana_cost
    end
  end

  class FindMinionRangeFromMinionType < ApplicationService
    attr_reader :minion_type

    def initialize(minion_type)
      @minion_type = minion_type
    end

    def call
      MinionStat.find_by(minion_type: minion_type).range
    end
  end

  class FindMinionStatsFromMinionID < ApplicationService
    attr_reader :minion_id

    def initialize(minion_id)
      @minion_id = minion_id
    end

    def call
      minion_type = SummonedMinion.find(@minion_id).minion_type
      MinionStat.find_by(minion_type: minion_type)
    end
  end

  class CalculateDamage < ApplicationService
    attr_reader :target, :minion

    def initialize(minion, target)
      @minion = minion
      @target = target
    end

    def call
      MinionStat.find_by(minion_type: @minion.minion_type).attack - MinionStat.find_by(minion_type: @target.minion_type).defense
    end
  end

  class TransformPositionIntoXYHash < ApplicationService
    attr_reader :position

    def initialize(position)
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
end