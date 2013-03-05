class WolvesController < ApplicationController

  require 'rqrcode'
  Google::UrlShortener::Base.api_key = "AIzaSyDSLr8Nouou-Lvx7TjoxiWmKQHXfxd9cVo"

  before_filter :signed_in_user, :only => [:new, :create, :edit, :destroy]


  def new
  end

  def create
    @wolf = current_user.wolves.build(params[:wolf])

    if @wolf.save
      # add root smoke
      @smoke = Smoke.create(:user_id => current_user.id, :wolf_id =>@wolf.id, :parent_user_id => current_user.id)
      
      # post the search request to twitter or facebook. 
      unless current_user.authorizations.find_by_provider("twitter").nil?

      auth = current_user.authorizations.find_by_provider("twitter")
      access_token = prepare_access_token(auth['token'], auth['secret'])
      access_token.request(:post, "http://api.twitter.com/1/statuses/update.json", :status => @smoke.wolf.user.name + ' posted: ' + @smoke.wolf.content + ' click to spread: http://'+ URI.parse(url_for(:only_path => false)).host + '/spread/' + @smoke.url_token )

      end

      unless current_user.authorizations.find_by_provider("facebook").nil?

      auth = current_user.authorizations.find_by_provider("facebook")
      access_token = FbGraph::User.me(auth['token'])
      access_token.feed!(:message => @smoke.wolf.user.name + ' posted: ' + @smoke.wolf.content + ' click to spread: http://'+ URI.parse(url_for(:only_path => false)).host + '/spread/' + @smoke.url_token ,
       :name => "99 red ballon")
      
      end

      # generate QR code 
      @qr = RQRCode::QRCode.new(URI.parse(url_for(:only_path => false)).host + ":3000/spread/" + @smoke.url_token, size: 10)

      @qrsvg = @qr.to_svg(:px =>2)
      # generate shorten url from google API
      # turned off to do local test
      @url =Google::UrlShortener.shorten!("http://"+"#{URI.parse(url_for(:only_path => false)).host + ":3000/spread/" + @smoke.url_token}")
      #@url =  "http://"+"#{URI.parse(url_for(:only_path => false)).host + ":3000/spread/" + @smoke.url_token}"

      # flash the success message  
      flash[:success] = "Event created! posted to  t/f,  Link: #{URI.parse(url_for(:only_path => false)).host + ":3000/spread/" + @smoke.url_token}"
      # ---> comment out redirect to get ajax response
      #redirect_to root_path

      # add post to social media instead of included link in the flash
    else
      # ---> comment out redirect to get ajax response 
      #redirect_to root_path
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
    @skip_footer = true
    @wolf = Wolf.find(params[:id])
    @smokes = @wolf.smokes

    # if current_user.smoked?(@wolf).nil?
    #   @smoke = current_user.wolf_shot?(@wolf).smoke
    # elsif current_user.smoked?(@wolf).parent.nil?
    #   @smoke = current_user.smoked?(@wolf)
    # else
    #   @smoke = current_user.smoked?(@wolf).parent
    # end 

    @smoke = current_user.smoked?(@wolf)


    # generate QR code 
    @qr = RQRCode::QRCode.new(URI.parse(url_for(:only_path => false)).host + ":3000/spread/" + @smoke.url_token, size: 10)

    @qrsvg = @qr.to_svg(:px =>2)
    # generate shorten url from google API
    # turned off to do local test
    @url =Google::UrlShortener.shorten!("http://"+"#{URI.parse(url_for(:only_path => false)).host + ":3000/spread/" + @smoke.url_token}")
    
    #@url =  "http://"+"#{URI.parse(url_for(:only_path => false)).host + ":3000/spread/" + @smoke.url_token}"


    if signed_in?
      @wolf_feed_items = current_user.wolf_feed
      @shoot_feed_items = current_user.descendent_shoots(@wolf)
    else
    end

    @answer = current_user.smoke_shot?(@smoke)


  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

end
