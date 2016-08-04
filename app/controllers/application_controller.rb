class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  def login(user)
    session[:session_token] = user.session_token
  end

  def logout
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end


  def check_login
    unless current_user.nil?
      redirect_to cats_url
    end
  end

end
