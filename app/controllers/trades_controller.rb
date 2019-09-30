class TradesController < ApplicationController
 before_action :set_item
 before_action :logged_in_user,    only: [:new, :create]  
    
    

 
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
      $current_item = nil
      proceed(@trade)
      redirect_to newpayment_path
    else
      render 'new'
    end
  end   
 
 def purchased
 @trade = Trade.all
 end
 
 def show
 @trade = Trade.find(params[:id])
 end
 
  def edit
    @trade = Trade.find(params[:id])
    if (@trade.status == true)
    flash[:danger] = "You have already paid for the transaction"
    redirect_to purchased_path
    end
    if (@trade.item.quantity) == 0
    flash[:danger] = "The book you looking for is run out of stock, The order have been canceled"
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
    params.require(:trade).permit(:user_id, :buyquantity, :paymethod)
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
   

end
