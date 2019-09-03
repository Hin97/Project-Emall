class StaticPagesController < ApplicationController
  def home
    @item = current_user.items.build if logged_in?
    
  end
end
