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

  class DeleteSessionsByUserUuid < ApplicationService
    attr_reader :user_uuid

    def initialize(user_uuid)
      @user_uuid = user_uuid
    end

    def call
      id_of_a_user = User.find_by(uuid: user_uuid).id
      Session.where(user_id: id_of_a_user).delete_all
    end
  end
end