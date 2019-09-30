class PaymentsController < ApplicationController
  before_action :set_trade
  before_action :logged_in_user,  only: [:new, :create, :show]  
  before_action :correct_user,   only: :show
 
  def new
  if (@trade.status == false)
    @payment = Payment.new
  else
    flash[:danger] = "You have already paid for this transaction"
  end
  end

  def create
    @payment = @trade.build_payment(payment_params)
  if @payment.save
    flash[:success] = "You have paid your order, Thank you!"
    @trade.update_attributes(status: true);
    reduce(@trade)
    $current_paymethod = nil
    $current_trade = nil
    redirect_to current_user
  else
    render 'new'
  end
  end
  
  def show
    @payment = Payment.find(params[:id])
  end
  
 private 
  
 def set_trade
 if ($current_trade.nil?)
 flash[:danger] = "please selete a transaction to pay for"
 else
 @trade=$current_trade
 end
 end
  
    def payment_params
    params.require(:payment).permit(:cardname, :cardnumber, :expmm, :expyy, :cvv)
    end

  
  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
    store_location
    flash[:danger] = "Please log in."
    redirect_to login_url
    end
  end
  
    def correct_user
      @item = current_user.items.find_by(id: params[:id])
      redirect_to root_url if @item.nil?
    end
    
end
