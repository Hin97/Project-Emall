class Trade < ApplicationRecord
    belongs_to :item
    has_one :payment, dependent: :destroy
    validates :user_id, presence: true
    validates :buyquantity, presence: true
    validates :totalprice, presence: true
    
    
    
end
