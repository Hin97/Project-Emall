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
    @items = Item.all
  end
  
  
  
  def destroy
    @item.destroy
    flash[:success] = "Item deleted"
    redirect_to request.referrer || root_url
  end
  
  
  
  # For transaction
  
  def newtransaction
    @item = Item.find(params[:id])
    @transaction = Transaction.new
  end

  def createtransaction
    @transaction = @item.transactions.build(transac_params)
    @transaction.totalprice = totalprice
    if @transaction.save
      flash[:success] = "Please pay in order to complete transaction!"
      redirect_to current_user
    else
      render 'new'
    end
  end 

  private

  # For item 
    def item_params
      params.require(:item).permit(:name, :price, :description, :quantity, :year, :condition)
    end
    
    def cateid_params
      params.require(:cate_ids)
    end
    
  # For transaction
  
    def transac_params
    params.require(:transaction).permit(:user_id, :Buyquantity)
    end
    
    def totalprice
    @noquantity = params.require(:transaction).permit(:Buyquantity)
    @totalprice = @noquantity * @item.price
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