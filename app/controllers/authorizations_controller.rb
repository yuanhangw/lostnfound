class AuthorizationsController < ApplicationController
  before_filter :siged_in_user!, :except => [:create, :signin, :signup, :newaccount, :failure]
  
  protect_from_forgery :except => :create     # see https://github.com/intridea/omniauth/issues/203

# callback: success
# This handles signing in and adding an authentication authorization to existing accounts itself
# It renders a separate view if there is a new user to create
  def create
    # get the authorization parameter from the Rails router
    params[:authorization] ? authorization_route = params[:authorization] : authorization_route = 'No authorization recognized (invalid callback)'
    # get the full hash from omniauth
    omniauth = request.env['omniauth.auth']
    flash[:success] = omniauth['credentials']['token']
    # continue only if hash and parameter exist
    if omniauth and params[:authorization]

      # map the returned hashes to our variables first - the hashes differs for every authorization
      
      # create a new hash
      @authhash = Hash.new
      
      if authorization_route == 'facebook'
        omniauth['info']['email'] ? @authhash[:email] =  omniauth['info']['email'] : @authhash[:email] = ''
        omniauth['info']['name'] ? @authhash[:name] =  omniauth['info']['name'] : @authhash[:name] = ''
        omniauth['credentials']['token'] ? @authhash[:token] =  omniauth['credentials']['token'] : @authhash[:token] = ''
        omniauth['credentials']['secret'] ? @authhash[:secret] =  omniauth['credentials']['secret'] : @authhash[:secret] = ''
        omniauth['uid'] ?  @authhash[:uid] =  omniauth['uid'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''
      elsif authorization_route == 'google_oauth2'
        omniauth['info']['email'] ? @authhash[:email] =  omniauth['info']['email'] : @authhash[:email] = ''
        omniauth['info']['name'] ? @authhash[:name] =  omniauth['info']['name'] : @authhash[:name] = ''
        omniauth['credentials']['token'] ? @authhash[:token] =  omniauth['credentials']['token'] : @authhash[:token] = ''
        omniauth['credentials']['secret'] ? @authhash[:secret] =  omniauth['credentials']['secret'] : @authhash[:secret] = ''        
        omniauth['uid'] ?  @authhash[:uid] =  omniauth['uid'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''  
      elsif authorization_route == 'twitter'
        omniauth['info']['email'] ? @authhash[:email] =  omniauth['info']['email'] : @authhash[:email] = (omniauth['info']['name']).gsub(" ", "_")+'@twitter.com'
        omniauth['info']['name'] ? @authhash[:name] =  omniauth['info']['name'] : @authhash[:name] = ''
        omniauth['credentials']['token'] ? @authhash[:token] =  omniauth['credentials']['token'] : @authhash[:token] = ''
        omniauth['credentials']['secret'] ? @authhash[:secret] =  omniauth['credentials']['secret'] : @authhash[:secret] = ''
        omniauth['uid'] ? @authhash[:uid] = omniauth['uid'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''
      elsif authorization_route == 'github'
        omniauth['user_info']['email'] ? @authhash[:email] =  omniauth['user_info']['email'] : @authhash[:email] = ''
        omniauth['user_info']['name'] ? @authhash[:name] =  omniauth['user_info']['name'] : @authhash[:name] = ''
        omniauth['credentials']['token'] ? @authhash[:token] =  omniauth['credentials']['token'] : @authhash[:token] = ''
        omniauth['credentials']['secret'] ? @authhash[:secret] =  omniauth['credentials']['secret'] : @authhash[:secret] = ''        
        omniauth['extra']['user_hash']['id'] ? @authhash[:uid] =  omniauth['extra']['user_hash']['id'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] =  omniauth['provider'] : @authhash[:provider] = ''  
      elsif ['google', 'yahoo', 'myopenid', 'open_id'].index(authorization_route) != nil
        omniauth['info']['email'] ? @authhash[:email] =  omniauth['info']['email'] : @authhash[:email] = ''
        omniauth['info']['name'] ? @authhash[:name] =  omniauth['info']['name'] : @authhash[:name] = ''
        omniauth['credentials']['token'] ? @authhash[:token] =  omniauth['credentials']['token'] : @authhash[:token] = ''
        omniauth['credentials']['secret'] ? @authhash[:secret] =  omniauth['credentials']['secret'] : @authhash[:secret] = ''
        omniauth['uid'] ? @authhash[:uid] = omniauth['uid'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''
      else        
        # debug to output the hash that has been returned when adding new authorizations
        render :text => omniauth.to_yaml
        return
      end 
      
      if @authhash[:uid] != '' and @authhash[:provider] != ''
        
        auth = Authorization.find_by_provider_and_uid(@authhash[:provider], @authhash[:uid])

        # if the user is currently signed in, he/she might want to add another account to signin
        if signed_in?
          if auth
            flash[:notice] = 'Your account at ' + @authhash[:provider].capitalize + ' is already connected with this site.'
            redirect_to root_path
          else
            current_user.add_authorization(@authhash)
            flash[:notice] = 'Your ' + @authhash[:provider].capitalize + ' account has been added for signing in at this site.'
            redirect_to root_path
          end
        else
          if auth
            # signin existing user
            # in the session his user id and the authorization id used for signing in is stored
            sign_in auth.user
            #session[:authorization_id] = auth.id
          
            flash[:notice] = 'Signed in successfully via ' + @authhash[:provider].capitalize + '.'
            redirect_to root_url
          else
            # this is a new user; show signup; @authhash is available to the view and stored in the sesssion for creation of a new user
            #session[:authhash] = @authhash
            #render signup_authorizations_path
            #crappy way to bypass password requirement for user, potential loophole
             password = SecureRandom.hex
             user = User.new(name: @authhash[:name], email: @authhash[:email], password: password, password_confirmation: password)
             user.authorizations.build(provider: @authhash[:provider], uid: @authhash[:uid], token: @authhash[:token], secret: @authhash[:secret])
             user.save
             flash[:success] = "Hi #{user.name}! You've signed up via #{@authhash[:provider]}."
             sign_in user
             redirect_back_or root_path   
          end
        end
      else
        flash[:error] =  'Error while authenticating via ' + authorization_route + '/' + @authhash[:provider].capitalize + '. The authorization returned invalid data for the user id.'
        redirect_to signin_path
      end
    else
      flash[:error] = 'Error while authenticating via ' + authorization_route.capitalize + '. The authorization did not return valid data.'
      redirect_to signin_path
    end
  end

end
