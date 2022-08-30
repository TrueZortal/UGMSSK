class SessionsController < ApplicationController
  def destroy
    session.delete(:current_user_uuid)
    flash[:notice] = "Logged out!"
    redirect_to root_path
  end
end