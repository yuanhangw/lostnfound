class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper


  helper_method :omniauth_current_user

  private

  def omniauth_current_user
    session[:omniauth_current_user]
  end

end
