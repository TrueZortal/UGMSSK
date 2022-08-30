# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # rescue_from(Exception) do |e|
  #   EventLog.error(e)
  #   redirect_to controller: 'games', action: 'start', format: :html
  # end

  private

  def current_user
    @_current_user ||= session[:current_user_uuid] &&
      User.find_by(uuid: session[:current_user_uuid])
  end
end
