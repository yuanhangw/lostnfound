class StaticPagesController < ApplicationController
  def home
    @skip_footer = true
    @user = User.new
    @wolf = @user.wolves.build

    if signed_in?
      @wolf_feed_items = current_user.wolf_feed
    end

  end

  def help
  end

  def about
  end

  def contact
  end
end
