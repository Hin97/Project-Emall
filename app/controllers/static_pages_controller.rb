class StaticPagesController < ApplicationController
  def home
  end
  
  def contact
    @user = User.find(1)
  end
  
end
