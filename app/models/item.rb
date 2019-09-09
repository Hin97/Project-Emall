class Item < ApplicationRecord
    belongs_to :user
    has_many :categorizations
    has_many :categories, through: :categorizations
    has_many :trades
    validates :user_id, presence: true
    validates :price, presence: true
    validates :condition, presence: true
    validates :description, presence: true, length: { maximum: 100 }
    validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    
    CONDITION_LIST = ["Used", "Brand New"]
end
