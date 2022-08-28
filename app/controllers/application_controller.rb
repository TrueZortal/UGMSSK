# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from(Exception) do |e|
    EventLog.error(e)
    redirect_to root_path
  end
end
