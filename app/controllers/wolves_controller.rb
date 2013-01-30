class WolvesController < ApplicationController
  before_filter :signed_in_user, :only => [:new, :create, :edit, :destroy]

  def new
  end

  def create
    @wolf = current_user.wolves.build(params[:wolf])

    if @wolf.save
      # add root smoke
      @smoke = Smoke.create(:user_id => current_user.id, :wolf_id =>@wolf.id, :parent_user_id => current_user.id)
      
      unless current_user.authorizations.find_by_provider("twitter").nil?

      auth = current_user.authorizations.find_by_provider("twitter")
      access_token = prepare_access_token(auth['token'], auth['secret'])
      access_token.request(:post, "http://api.twitter.com/1/statuses/update.json", :status => @smoke.wolf.user.name + ' posted: ' + @smoke.wolf.content + ' click to spread: http://hidden-brook-5001.herokuapp.com'+ smoke_path(@smoke) )

      end

      unless current_user.authorizations.find_by_provider("facebook").nil?

      auth = current_user.authorizations.find_by_provider("facebook")
      access_token = FbGraph::User.me(auth['token'])
      access_token.feed!(:message => @smoke.wolf.user.name + ' posted: ' + @smoke.wolf.content + ' click to spread: '+ URI.parse(url_for(:only_path => false)).host + '/spread/' + @smoke.url_token ,
       :name => "99 red ballon")
      
      end

      flash[:success] = "Event created! posted to  t/f,  Link: #{URI.parse(url_for(:only_path => false)).host + "/spread/" + @smoke.url_token}"
      redirect_to root_path
      # add post to social media instead of included link in the flash
    else
      redirect_to root_path
    end
  end
 
  def edit
  end
  
  def destroy
  end
  
  def index
    @wolf = current_user.wolves.build if signed_in?
    @wolves = Wolf.paginate(:page => params[:page])
  end

  def show
    @wolf = Wolf.find(params[:id])
    @smokes = @wolf.smokes.paginate(:page => params[:page])
    @smoke = current_user.smoked?(@wolf)
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
