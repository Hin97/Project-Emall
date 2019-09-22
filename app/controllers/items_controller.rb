class ItemsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy

#Controller for items related 

  def new
    @item = Item.new
  end
  
  def create
    @item = current_user.items.build(item_params)
    if @item.save
      @item.category_ids = cateid_params
      flash[:success] = "Post book successfully!"
      redirect_to current_user
    else
      render 'new'
    end
  end
  
  def show
  @item = Item.find(params[:id])
  end
  
  def index
  @item = Item.all
  end
  
  
  def search
    @item = Item.where("name LIKE ?","%" + params[:q] + "%")
    @last = Item.order("created_at desc").limit(10)
    @keyword = params[:q]
  end
  
  
  
  def destroy
    @item.destroy
    flash[:success] = "Item deleted"
    redirect_to current_user
  end
  

  private

  # For item 
    def item_params
      params.require(:item).permit(:name, :price, :description, :quantity, :year, :condition, :author, :image)
    end
    
    def cateid_params
      params.require(:cate_ids)
    end
    
    
    def correct_user
      @item = current_user.items.find_by(id: params[:id])
      redirect_to root_url if @item.nil?
    end
    
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
      store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
end