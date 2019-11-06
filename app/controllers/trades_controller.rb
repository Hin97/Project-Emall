class TradesController < ApplicationController
 before_action :set_item
 before_action :logged_in_user,    only: [:purchased, :sold, :show, :edit, :update, :destory]  
 before_action :exist_trade, only: [:edit, :update, :destory, :show]
 before_action :correct_buyer,   only: [:edit, :update, :destory]
 before_action :admin_no_transactions,   only: [:new, :create,:edit, :update]
 before_action :correct_user,   only: :show
 
 # For trade
  def new
    if (@item.nil?)
    flash[:danger] = "Please selete a book to purchase"
    redirect_to current_user
    else
    if (current_user == @item.user)
    flash[:danger] = "You cannot buy your own books"
    redirect_to current_user
    else
    @trade = Trade.new
    end
    end
  end

  def create
    @trade = @item.trades.build(transac_params)
    calculation(@item,@trade.buyquantity)
    @trade.totalprice = @calculation
    if @trade.save
      flash[:success] = "Please proceed to payment in order to complete your purchase"
      proceed(@trade)
      redirect_to newpayment_path
    else
      render 'new'
    end
  end   
 
 def purchased
 @trade = Trade.all
 @count = false
 end
 
 def sold
 @trade = Trade.all
 @count = false
 end
 
 def show
 @trade = Trade.find(params[:id])
 if (@trade.item.user == current_user && @trade.payment.status.nil?)
 flash[:danger] = "You don't have the permission!"  
 redirect_to current_user
 end
 end
 
  def edit
    @trade = Trade.find(params[:id])
    if !(@trade.payment.nil?)
    if (@trade.payment.status == "Completed")
    flash[:danger] = "You have already paid for the transaction"
    redirect_to purchased_path
    end
    end
    if (@trade.item.quantity) == 0
    flash[:danger] = "The book you looking for is run out of stock or has been take off, Your order have been canceled"
    @trade.destroy
    redirect_to purchased_path
    end
    
  end

  def update
    @trade = Trade.find(params[:id])
    if @trade.update_attributes(transac_params)
      $current_item = nil
      proceed(@trade)
      redirect_to newpayment_path
    else
      render 'edit'
    end
  end

  def destroy
    Trade.find(params[:id]).destroy
    flash[:success] = "transaction canceled"
    redirect_to current_user
  end
 
 private
 
 # For trade
    def transac_params
    params.require(:trade).permit(:user_id, :buyquantity)
    end
    
    
  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
    store_location
    flash[:danger] = "Please log in."
    redirect_to login_url
    end
  end
  
   def set_item
    @item = $current_item
   end
   
    def correct_buyer
    @trade = Trade.find(params[:id])
    if (!(@trade.user_id == current_user.id))
    flash[:danger] = "You are not the correct user"
    redirect_to root_url 
    end
    end
    
    def correct_user
    @trade = Trade.find(params[:id])
    if (@trade.user_id == current_user.id || @trade.item.user == current_user || current_user.admin?)
    else
    flash[:danger] = "You don't have the permission"
    redirect_to root_url 
    end
    end
    
      def admin_no_transactions
      if (current_user.nil? == false)
      if current_user.admin?
      flash[:danger]= "Admin cannot make any payments"
      redirect_to current_user
      end
      end
      end
      
    def exist_trade
    @trade = Trade.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    if @trade.nil?
    redirect_to root_url
    flash[:danger]= "Transaction is not exist"
    end
    end

end
