class ShootsController < ApplicationController
  before_filter :signed_in_user, :only => [:new, :create, :edit, :destroy]

  def new
  end

  def create
    @shoot = Shoot.new(params[:shoot])
    @shoot.save!
    redirect_to(:back) 
  end

  def edit
  end

  def destroy
  end

  def show
  end
end 
