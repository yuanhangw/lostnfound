class SmokesController < ApplicationController
  before_filter :signed_in_user  

  def new
  end

  def create
    @smoke = Smoke.new(params[:smoke])
    @smoke.save!
    redirect_to root_path
    if @smoke.save

      if current_user.authorizations.find_by_provider("twitter")!=nil

      auth = current_user.authorizations.find_by_provider("twitter")
      access_token = prepare_access_token(auth['token'], auth['secret'])
      access_token.request(:post, "http://api.twitter.com/1/statuses/update.json", :status => @smoke.wolf.user.name + ' posted: ' + @smoke.wolf.content + ' click to spread: http://hidden-brook-5001.herokuapp.com'+ smoke_path(@smoke) )

      elsif current_user.authorizations.find_by_provider("facebook")!=nil

      auth = current_user.authorizations.find_by_provider("facebook")
      access_token = FbGraph::User.me(auth['token'])
      access_token.feed!(:message => @smoke.wolf.user.name + ' posted: ' + @smoke.wolf.content + ' click to spread: http://hidden-brook-5001.herokuapp.com'+ smoke_path(@smoke) ,
       :name => "99 red ballon")
      end


      flash[:sucess] = "Event Spreaded! posted to f/t,  Link: #{smoke_path(@smoke)}"
    else
    end
#    @wolf = @smoke.wolf
#    respond_to do |format|
#      format.html { redirect_to @smoke.wolf }
#      format.js
#    end
  end

  def show
     @smoke = Smoke.find(params[:id])
     @wolf =@smoke.wolf
     @user = User.new

    if signed_in?
      @wolf_feed_items = current_user.wolf_feed.paginate(page: params[:page])
    else
    end

  end

    private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

end
