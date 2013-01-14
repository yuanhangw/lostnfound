class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      sign_in_ user
      redirect_back_or root_path
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def omni_create

    auth_hash = request.env['omniauth.auth']

    if signed_in?
      # Means our user is signed in. Add the authorization to the user
      User.find(session[:user_id]).add_provider(auth_hash)
      flash[:success] = "You can now login using #{auth_hash["provider"].capitalize} too!"
    else
       # Log him in or sign him up
       # Log him in or sign him up
       @authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
       if @authorization
         flash[:success] = "Welcome back #{@authorization.user.name}! You have already signed up."
         user = User.find_by_email(auth_hash["info"]["email"])
         sign_in_ user
         redirect_back_or root_path
       else
         #crappy way to bypass password requirement for user, potential loophole
         password = SecureRandom.hex
         user = User.new(name: auth_hash["info"]["name"], email: auth_hash["info"]["email"], password: password, password_confirmation: password)
         user.authorizations.build(provider: auth_hash["provider"], uid: auth_hash["uid"])
         user.save
         flash[:success] = "Hi #{user.name}! You've signed up."
         sign_in_ user
         redirect_back_or root_path    
       end

    end


   #######   facebook only solution    ######
   # auth_hash = request.env['omniauth.auth']
   # @authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
   # if @authorization
   #   flash[:success] = "Welcome back #{@authorization.user.name}! You have already signed up."
   #   user = User.find_by_email(auth_hash["info"]["email"])
   #   sign_in user
   #   redirect_back_or root_path
   # else
   #   #crappy way to bypass password requirement for user, potential loophole
   #   password = SecureRandom.hex
   #   user = User.new(name: auth_hash["info"]["name"], email: auth_hash["info"]["email"], password: password, password_confirmation: password)
   #   user.authorizations.build(provider: auth_hash["provider"], uid: auth_hash["uid"])
   #   user.save
   #   flash[:success] = "Hi #{user.name}! You've signed up."
   #   sign_in user
   #   redirect_back_or root_path    
   # end

  end


  def destroy
    sign_out
    redirect_to root_url
  end

  def omniauth_create
  
  auth_hash = request.env['omniauth.auth']
  render :text => auth_hash.inspect
  end


  def omniauth_destroy
    session.delete(:omniauth_current_user)
    redirect_to root_path

  
  end


end
