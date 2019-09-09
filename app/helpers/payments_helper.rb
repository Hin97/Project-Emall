module PaymentsHelper
    def reduce(trade)
    @newquantity = trade.item.quantity - trade.buyquantity
    trade.item.update_attributes(quantity: @newquantity)
    end
end
