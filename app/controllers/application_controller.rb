# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from(Exception) do |e|
    EventLog.error(e)
    redirect_to root_path
  end

  private

  def current_user
    @_current_user ||= session[:current_user_uuid] &&
      User.find_by(uuid: session[:current_user_uuid])
  end
end
