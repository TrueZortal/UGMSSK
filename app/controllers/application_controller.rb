# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper

  before_action :authenticate_uuid_session

  def authenticate_uuid_session
    if logged_in?
      current_user
    end
  end
  # rescue_from(Exception) do |e|
  #   EventLog.error(e)
  #   redirect_to root_path
  # end
end
