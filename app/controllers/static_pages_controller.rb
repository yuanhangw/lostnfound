class StaticPagesController < ApplicationController
  def home
    @skip_footer = false
    @user = User.new
    @wolf = @user.wolves.build
  end

  def help
  end

  def about
  end

  def contact
  end
end
