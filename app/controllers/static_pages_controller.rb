class StaticPagesController < ApplicationController
  def home
    @skip_footer = false
    @user = User.new
    @wolf = @user.wolves.build

    if signed_in?
      @wolf_feed_items = current_user.wolf_feed.paginate(page: params[:page])
    end

  end

  def help
  end

  def about
  end

  def contact
  end
end
