class Item < ApplicationRecord
    belongs_to :user
    has_many :categorizations
    has_many :categories, through: :categorizations
    has_many :trades
    mount_uploader :image, ImageUploader
    validates :user_id, presence: true
    validates :price, presence: true
    validates :condition, presence: true
    validates :description, presence: true, length: { maximum: 100 }
    validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :image, presence:true
    validate  :image_size
    CONDITION_LIST = ["Used", "Brand New"]
    
    
        # Validates the size of an uploaded picture.
    def image_size
      if image.size > 5.megabytes
        errors.add(:image, "should be less than 5MB")
      end
    end
    
end
