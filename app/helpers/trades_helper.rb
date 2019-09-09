module TradesHelper
def calculation(item,quantity)
@calculation = item.price * quantity.to_f
end

def pay(item)
    $current_item = item
    newtrade_path
end

def proceed(trade)
    $current_trade = trade
    $current_paymethod = trade.paymethod
end


end
