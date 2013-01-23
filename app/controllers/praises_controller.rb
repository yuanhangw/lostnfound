class PraisesController < ApplicationController
  before_filter :signed_in_user, :only => [:new, :create, :edit, :destroy]
  
  def new
  end

  def create
    @praise = Praise.new(params[:praise])
    @praise.save!
    redirecto_to @praise.shoot
  end

  def edit
  end

  def destroy
  end

end
