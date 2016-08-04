class SessionsController < ApplicationController
  before_action :check_login
  skip_before_action :check_login, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:user_name],
      params[:user][:password]
    )

    if @user.nil?
      flash[:errors] ||= []
      flash[:errors] << "User not found"
      redirect_to new_session_url
    else
      @user.reset_session_token!
      login(@user)
      redirect_to cats_url
    end
  end

  def destroy
    logout
    redirect_to cats_url
  end

  private

  def session_params
    params.require(:session).permit(:session_token)
  end
end
