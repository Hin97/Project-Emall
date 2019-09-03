class Item < ApplicationRecord
    belongs_to :user
    has_many :categorizations
    has_many :categories, through: :categorizations, dependent: :destroy
    validates :user_id, presence: true
    validates :price, presence: true
    validates :description, presence: true, length: { maximum: 100 }
    validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
