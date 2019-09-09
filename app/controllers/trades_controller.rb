class TradesController < ApplicationController
 before_action :set_item
 before_action :logged_in_user,    only: [:new, :create]  
    
  # For trade
  def new
    if ($current_item.nil?)
    flash.now[:danger] = "Please selete a book to purchase"
    redirect_to current_user
    else
    @trade = Trade.new
    end
  end

  def create
      
    @trade = @item.trades.build(transac_params)
    calculation(@item,@trade.buyquantity)
    @trade.totalprice = @calculation
    if @trade.save
      
      if (@trade.buyquantity > @item.quantity)
       @trade.destroy
       flash.now[:danger] = "The supplier doesn't have enough stock"
       render 'new'   
      else
      flash[:success] = "Please proceed to payment in order to complete your purchase"
      $current_item = nil
      proceed(@trade)
      redirect_to newpayment_path
      end
      
    else
      render 'new'
    end
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
