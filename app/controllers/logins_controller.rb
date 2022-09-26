class LoginsController < ApplicationController
  def login
    if logged_in?
      redirect_to root_path
    end
  end

  def create
    @user = User.new(name: user_params[:name], uuid: SecureRandom.uuid)
    if @user.save
      session[:current_user_uuid] = @user.uuid
      session[:token] = SecureRandom.urlsafe_base64
      sesh = Session.new(user_id: @user.id, token: session[:token])
      sesh.save
      flash[:notice] = "Successfully logged in as #{@user.name}!"
      redirect_to root_path
    else
      redirect_to login_path
    end
  end

  private

  def user_params
    params.permit(:name, :authenticity_token, :commit)
  end
end
