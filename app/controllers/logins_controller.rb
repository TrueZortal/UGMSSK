class LoginsController < ApplicationController
  def login
    if session[:current_user_uuid]
      @current_user = User.find_by(uuid: session[:current_user_uuid] )
      redirect_to root_path
    end
  end

  def new
    @user = User.new
  end

  def create
    p user_params['name']
    @user = User.new(name: user_params[:name], uuid: SecureRandom.uuid)
    if @user.save
      session[:current_user_uuid] = @user.uuid
      flash[:notice] = "Successfully logged in as #{@user.name}!"
      redirect_to root_path
    else
      redirect_to controller: 'logins', action: 'login'
    end
  end

  private

  def user_params
    params.permit(:name, :authenticity_token, :commit)
  end
end