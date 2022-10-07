# frozen_string_literal: true

class SessionsController < ApplicationController
  def destroy
    JanitorManager::DeleteSessionsByUserUuid.call(session[:current_user_uuid])
    session.delete(:current_user_uuid)
    flash[:notice] = 'Logged out!'
    redirect_to root_path
  end
end
