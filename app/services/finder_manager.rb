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
end