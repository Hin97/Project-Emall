class Trade < ApplicationRecord
    belongs_to :item
    has_one :payment
    validates :user_id, presence: true
    validates :buyquantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :totalprice, presence: true, numericality: { greater_than: 0 }
    validates :paymethod, presence: true
    
    TYPE_LIST = ["Credit Card", "Paypal"]
end
