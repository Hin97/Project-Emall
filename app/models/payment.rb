class Payment < ApplicationRecord
     belongs_to :trade
     CARD_NUMBER_REGEX = /\A[0-9]{16}/is
     CARD_NAME_REGEX = /\w+/s
     CARD_EXPIRE_REGEX = /\A[0-9]{2}/is
     CARD_CVV_REGEX = /\A[0-9]{3}/is
     validates :cardname,  presence: true, format: { with: CARD_NAME_REGEX }, if: -> {$current_paymethod == "Credit Card"}
     validates :cardnumber,  presence: true, format: { with: CARD_NUMBER_REGEX }, if: -> {$current_paymethod == "Credit Card"}
     validates :expmm,  presence: true, format: { with: CARD_EXPIRE_REGEX }, if: -> {$current_paymethod == "Credit Card"}
     validates :expyy,  presence: true, format: { with: CARD_EXPIRE_REGEX }, if: -> {$current_paymethod == "Credit Card"}
     validates :cvv,  presence: true, format: { with: CARD_CVV_REGEX }, if: -> {$current_paymethod == "Credit Card"}
     
     

end
