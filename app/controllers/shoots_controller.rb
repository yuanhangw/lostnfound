class ShootsController < ApplicationController
  before_filter :signed_in_user, :only => [:new, :create, :edit, :destroy]
  respond_to :js, :html


  def new
  end

  def create
    @shoot = Shoot.new(params[:shoot])
    @shoot.save!
    #let's try ajax dynamic update! 
    @wolf_feed_items = current_user.wolf_feed 
    #@wolf = Wolf.find(params[:id])
    @shoot_feed_items = current_user.descendent_shoots(@shoot.wolf)   
    #respond_with(@shoot)
    #redirect_to(:back) 
  end

  def edit
  end

  def destroy
  end

  def show
  end
end 
