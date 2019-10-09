class Payment < ApplicationRecord
  belongs_to :trade
  
  def paypal_url(return_path)
    values = {
        business: "Merchant@emall.com",
        cmd: "_xclick",
        upload: 1,
        return: "#{Rails.application.secrets.app_host}#{return_path}",
        invoice: id,
        amount: trade.item.price,
        item_name: trade.item.name,
        item_number: trade.item.id,
        quantity: trade.buyquantity,
        notify_url: "#{Rails.application.secrets.app_host}/hook"
    }
    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  end
  
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
