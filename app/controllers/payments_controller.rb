class PaymentsController < ApplicationController
  before_action :set_trade
  before_action :set_payment, only:[:show, :edit, :update]
  before_action :logged_in_user,  only: [:new, :create, :show, :edit, :update]
  before_action :admin_no_payment,   only: [:new, :create]
  before_action :correct_user,   only: [:show, :edit, :update]
 
  def new
  # if (@trade.payment.status == false)
    @payment = Payment.new
  # else
  #   flash[:danger] = "You have already paid for this transaction"
  # end
  end

  def create
  @payment = @trade.build_payment(payment_params)
  if @payment.save
  redirect_to @payment.paypal_url(payment_path(@payment))
  else
  render 'new'
  end
  end
  
  def show
  @payment = Payment.find(params[:id])
  end
  
  protect_from_forgery except: [:hook]
  def hook
    params.permit! # Permit all Paypal input params
    if (params == "INVALID")
    flash[:danger] = "message not equal"
    end
    
    if !(params == "VERIFIED")
    status = params[:payment_status]
    if status == "Completed"
      @payment = Payment.find(params[:invoice])
      @payment.update_attributes(notification_params: params, status: status, transaction_id: params[:txn_id], purchased_at: Time.now)
      reduce(@payment.trade)
      @payment.return_url(params)
    end
    end
    render nothing: true
  end
  
 private 
  
 def set_trade
 if ($current_trade.nil?)
 flash[:danger] = "please selete a transaction to pay for"
 else
 @trade=$current_trade
 end
 end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end
  
    def payment_params
    params.require(:payment).permit(:username, :email)
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
    @payment = Payment.find_by(id: params[:id])
    if (@payment.username == current_user.name && @payment.email == current_user.email)
    else
    flash[:danger] = "You don't have the permission"
    redirect_to root_url 
    end
    end
    
    def admin_no_payment
      if current_user.admin?
      flash[:danger]= "Admin cannot make any payments"
      redirect_to current_user
      end
    end
end
