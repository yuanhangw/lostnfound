class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper


  helper_method :omniauth_current_user

  private

  def omniauth_current_user
    session[:omniauth_current_user]
  end

  def prepare_access_token(oauth_token, oauth_token_secret)
            consumer = OAuth::Consumer.new("Q2xgUe6W5kpGtFSbHNtPAg", "QwoOTeYVG7tPCtfztRoER51AafXP5L1CXJ9oyCzi4",
                { :site => "http://api.twitter.com"
                })
            # now create the access token object from passed values
            token_hash = { :oauth_token => oauth_token,
                                         :oauth_token_secret => oauth_token_secret
                                     }
            access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
            return access_token
   end

end
