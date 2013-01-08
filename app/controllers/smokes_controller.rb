class SmokesController < ApplicationController
  before_filter :signed_in_user  

  def new
  end

  def create
    @smoke = Smoke.new(params[:smoke])
    @smoke.save!
    redirect_to root_path
    if @smoke.save
      flash[:sucess] = "Event Spreaded! posted to twitter,  Link: #{smoke_path(@smoke)}"
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

end
