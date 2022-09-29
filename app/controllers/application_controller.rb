# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper

  before_action :set_current_user

  # rescue_from(Exception) do |e|
  #   EventLog.error(e)
  #   redirect_to root_path
  # end
end
