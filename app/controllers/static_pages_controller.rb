class StaticPagesController < ApplicationController
  def home
    @skip_footer = true
  end

  def help
  end

  def about
  end

  def contact
  end
end
