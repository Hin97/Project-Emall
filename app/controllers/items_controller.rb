class ItemsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy, :edit, :update]
  before_action :exist_item, only: [:edit, :update, :destory, :show]
  before_action :admin_no_posts,   only: [:new, :create, :edit, :update]
  before_action :correct_user,   only: [:destroy, :edit, :update]

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
  @category = Category.all
  @width = 33.33
  end
  
  
  def search
    @item = Item.where("name LIKE ?","%" + params[:q] + "%")
    @last = Item.order("created_at desc").limit(10)
    @keyword = params[:q]
  end
  
  
  
  def destroy
    Item.find(params[:id]).destroy
    flash[:success] = "Item deleted"
    redirect_to items_path
  end
  
  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(item_params)
      flash[:success] = "Book updated"
      redirect_to @item
    else
      render 'edit'
    end
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
    if !(@item.nil?) || current_user.admin?
    else
      flash[:danger] = "You don't have the permission!"      
      redirect_to root_url
    end
    end
    
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
      store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    def admin_no_posts
      if current_user.admin?
      flash[:danger]= "Admin cannot make any posts"
      redirect_to current_user
      end
    end
    
    def exist_item
    @item = Item.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    if @item.nil?
    redirect_to root_url
    flash[:danger]= "Item is not exist"
    end
    end
    
end