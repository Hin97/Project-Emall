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
    # Define keyword for search 
    @keyword = params[:q]
    # Define cate for search
    @cat = params[:cate]
    # Split keywork into array
    @split = @keyword.split(" ")
    # split size
    @size = @split.size
    
    
    #Book start
    @itemA = Item.where("name LIKE ?","%" + @keyword + "%")
    # Initial an array  
    @showbook = []
    @x = 0
    # while loop
    while @x < @size
    @item = Item.where("name LIKE ?","%" + @split[@x] + "%")
    @item.each do |item|
    if @showbook.include?(item.id) == false
    @showbook.push(item.id)
    # end push loop
    end
    # end each loop
    end
    @x += 1
    # end while loop
    end
    @items = Item.where(id:@showbook)
    # Find books based on book name with keywork    
    # Book end
    
    # Category start
    @cate = Category.where("name LIKE ?","%" + @keyword + "%")
    # Initial an array  
    @showcate = []
    @y = 0
    # while loop
    while @y < @size
    @category = Category.where("name LIKE ?","%" + @split[@y] + "%")
    @category.each do |cate|
    if @showcate.include?(cate.id) == false
    @showcate.push(cate.id)
    # end push loop
    end
    # end each loop
    end
    @y += 1
    # end while loop
    end
    @categories = Category.where(id:@showcate)
    # Category end
    
    # Author start
    @auth = Item.where("author LIKE ?","%" + @keyword + "%")
    # Initial an array  
    @showauthor = []
    @z = 0
    # while loop
    while @z < @size
    @author = Item.where("author LIKE ?","%" + @split[@z] + "%")
    @author.each do |auth|
    if @showauthor.include?(auth.id) == false
    @showauthor.push(auth.id)
    # end push loop
    end
    # end each loop
    end
    @z += 1
    # end while loop
    end
    @authors = Item.where(id:@showauthor)
    # Author end
    
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