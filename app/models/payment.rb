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
  
  def return_url(link)
    "https://ipnpb.paypal.com/cgi-bin/webscr?cmd=_notify-validate&" + link.to_query
  end
end
