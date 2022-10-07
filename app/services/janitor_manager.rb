# frozen_string_literal: true

module JanitorManager
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
