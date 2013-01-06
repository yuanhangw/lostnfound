class WolvesController < ApplicationController
  before_filter :signed_in_user, :only => [:new, :create, :edit, :destroy]

  def new
  end

  def create
    @wolf = current_user.wolves.build(params[:wolf])
    if @wolf.save
      # add root smoke
      @smoke = Smoke.create(:user_id => current_user.id, :wolf_id =>@wolf.id, :parent_user_id => current_user.id)
      flash[:success] = "Event created!"
      redirect_to @wolf
    else
      render 'static_page/home'
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
  end

end
