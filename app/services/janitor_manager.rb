# frozen_string_literal: true

module JanitorManager
  # Deletes the session by user uuid
  class DeleteSessionsByUserUuid < ApplicationService
    attr_reader :user_uuid

    def initialize(user_uuid)
      super()
      @user_uuid = user_uuid
    end

    def call
      id_of_a_user = User.find_by(uuid: user_uuid).id
      Session.where(user_id: id_of_a_user).delete_all
    end
  end

  # Removes the game to user association
  class RemoveGameFromUser < ApplicationService
    attr_reader :user

    def initialize(user_uuid)
      super()
      @user = User.find_by(uuid: user_uuid)
    end

    def call
      user.game_id = ''
      user.save
    end
  end
end
