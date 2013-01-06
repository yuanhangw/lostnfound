class SmokesController < ApplicationController
  before_filter :signed_in_user  

  def new
  end

  def create
    @smoke = Smoke.new(params[:smoke])
    @smoke.save!
    redirect_to @smoke.wolf
#    if @smoke.save
#      flash[:sucess] = "Event Spreaded!"
#    else
#    end
#    @wolf = @smoke.wolf
#    respond_to do |format|
#      format.html { redirect_to @smoke.wolf }
#      format.js
#    end
  end
end
