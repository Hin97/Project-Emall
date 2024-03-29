class PaymentsController < ApplicationController
  before_action :set_trade, only:[:new,:create, :edit]
  before_action :set_payment, only:[:show, :edit, :update]
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
    @response = validate_IPN_notification(request.raw_post)
    # if (Payment.find(params[:invoice]).status.nil?)
    case @response
    when "VERIFIED"
    status = params[:payment_status]
    if status == "Completed"
      @payment = Payment.find(params[:invoice])
      @payment.update_attributes(notification_params: params, status: status, transaction_id: params[:txn_id], purchased_at: Time.now)
      reduce(@payment.trade)
      $current_item = nil
    redirect_to payment_path(@payment)
    end
    when "INVALID"
      flash[:danger] = "The verification is fail"
      redirect_to current_user
    else
      flash[:danger] = "Something wrong happen"
      redirect_to current_user
    end
  #   @api = PayPal::SDK::Merchant.new
  # if @api.ipn_valid?(request.raw_post)  # return true or false
  #   status = params[:payment_status]
  #   if status == "Completed"
  #     @payment = Payment.find(params[:invoice])
  #     @payment.update_attributes(notification_params: params, status: status, transaction_id: params[:txn_id], purchased_at: Time.now)
  #     reduce
  #   end
  # end
    head :ok
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

    def correct_user
    @payment = Payment.find_by(id: params[:id])
    if (current_user.nil? == false)
    if (@payment.username == current_user.name && @payment.email == current_user.email)
    else
    flash[:danger] = "You don't have the permission"
    redirect_to root_url 
    end
    end
    end
    
    def admin_no_payment
      if (current_user.nil? == false)
      if current_user.admin?
      flash[:danger]= "Admin cannot make any payments"
      redirect_to current_user
      end
      end
    end
    
    

protected
  def validate_IPN_notification(rawdata)
    sandbox = "#{Rails.application.secrets.sandbox}"
    uri = URI.parse(sandbox + '/webscr?cmd=_notify-validate')
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 60
    http.read_timeout = 60
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.use_ssl = true
    @response = http.post(uri.request_uri, rawdata,
                        'Content-Length' => "#{rawdata.size}",
                        'User-Agent' => "My custom user agent"
                      ).body
  end


end
