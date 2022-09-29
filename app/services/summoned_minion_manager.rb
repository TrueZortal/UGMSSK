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
end