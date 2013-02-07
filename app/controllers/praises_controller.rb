class PraisesController < ApplicationController
  before_filter :signed_in_user, :only => [:new, :create, :edit, :destroy]
  respond_to :js, :html

  def new
  end

  def create
    @praise = Praise.new(params[:praise])
    @praise.save!
    #redirect_to @praise.shoot
  end

  def edit
  end

  def destroy
  end

end
