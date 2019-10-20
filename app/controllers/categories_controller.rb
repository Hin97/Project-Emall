class CategoriesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :index]
  before_action :admin_user,  only: [:new, :create, :index]
  
  
  def new
  @category = Category.new
  end
  
  def destroy
    Category.find(params[:id]).destroy
    flash[:success] = "Category deleted"
    redirect_to categories_path
  end

  def create
    @category= Category.create(category_params)
    if @category.save
      flash[:success] = "Welcome to the EMALL!"
      redirect_to items_path
    else
      render 'new'
    end
  end

  def index
    @categories = Category.paginate(page: params[:page])
  end
  
  def show
  @category = Category.find(params[:id])
  @item = Item.all
  @count = false
  end
  
    private

    def category_params
      params.require(:category).permit(:name)
    end
    
        # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    def admin_user
    if (current_user.admin? == false)
    redirect_to(items_path)
    flash[:danger] = "You don't have the permission"
    end
    end
    
end
