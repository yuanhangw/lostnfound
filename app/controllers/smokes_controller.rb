class SmokesController < ApplicationController

  require 'rqrcode'
  Google::UrlShortener::Base.api_key = "AIzaSyDSLr8Nouou-Lvx7TjoxiWmKQHXfxd9cVo"


  before_filter :signed_in_user


  def new
  end

  def create
    @smoke = current_user.smokes.build(params[:smoke])
    @smoke.save!
    @wolf = @smoke.wolf

    #redirect_to(:back)

    if @smoke.save

      unless current_user.authorizations.find_by_provider("twitter").nil?

      auth = current_user.authorizations.find_by_provider("twitter")
      access_token = prepare_access_token(auth['token'], auth['secret'])
      access_token.request(:post, "http://api.twitter.com/1/statuses/update.json", :status => @smoke.wolf.user.name + ' posted: ' + @smoke.wolf.content + ' http://' + URI.parse(url_for(:only_path => false)).host + '/spread/'+ @smoke.url_token )

      end

      unless current_user.authorizations.find_by_provider("facebook").nil?

      auth = current_user.authorizations.find_by_provider("facebook")
      access_token = FbGraph::User.me(auth['token'])
      access_token.feed!(:message => @smoke.wolf.user.name + ' posted: ' + @smoke.wolf.content + 'http://' + URI.parse(url_for(:only_path => false)).host + '/spread/'+ @smoke.url_token ,
       :name => "99 red ballon")
      
      end

      # generate QR code 
      @qr = RQRCode::QRCode.new(URI.parse(url_for(:only_path => false)).host + "/spread/" + @smoke.url_token, size: 10)

      @qrsvg = @qr.to_svg(:px =>2)
      # generate shorten url from google API
      # turned off to do local test
      @url =Google::UrlShortener.shorten!("http://"+"#{URI.parse(url_for(:only_path => false)).host + "/spread/" + @smoke.url_token}")
      #@url =  "http://"+"#{URI.parse(url_for(:only_path => false)).host + ":3000/spread/" + @smoke.url_token}"



      flash[:sucess] = "Event Spreaded! posted to f/t,  Link: #{URI.parse(url_for(:only_path => false)).host + "/spread/" + @smoke.url_token}"
    else

    end


#    @wolf = @smoke.wolf
#    respond_to do |format|
#      format.html { redirect_to @smoke.wolf }
#      format.js
#    end
  end

  def show
#     @smoke = Smoke.find(params[:id])
    @smoke = Smoke.find_by_url_token(params[:token])
    @wolf =@smoke.wolf
    @user = User.new

    if signed_in?
      @wolf_feed_items = current_user.wolf_feed
      @shoot_feed_items = @smoke.shoots
    else
    end

  end



    private

    def signed_in_user
      unless signed_in?
        store_location
        #implement auto signin here 
        redirect_to signin_url, notice: "Please sign in."
      end
    end

end
