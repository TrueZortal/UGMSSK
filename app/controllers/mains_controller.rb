class MainsController < ApplicationController
  def index
    if session[:current_user_uuid]
      @current_user = User.find_by(uuid: session[:current_user_uuid] )
    else
      redirect_to login_path
    end
  end
end