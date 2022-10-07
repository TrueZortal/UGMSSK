# frozen_string_literal: true

module ApplicationHelper
  def logged_in?
    session[:current_user_uuid] && Session.exists?(token: session[:token])
  end

  def current_user
    @current_user ||= User.find_by(uuid: session[:current_user_uuid])
  end

  def restrict_access
    redirect_to login_path unless logged_in?
  end

  def set_current_user
    current_user if logged_in?
  end
end
