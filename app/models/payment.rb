class Payment < ApplicationRecord
     belongs_to :trade
     validates :cardname,  presence: true, format: { with: CARD_NAME_REGEX }, if: -> {$current_paymethod == "Credit Card"}
     validates :cardnumber,  presence: true, format: { with: CARD_NUMBER_REGEX }, if: -> {$current_paymethod == "Credit Card"}
     validates :expmm,  presence: true, format: { with: CARD_EXPIRE_REGEX }, if: -> {$current_paymethod == "Credit Card"}
     validates :expyy,  presence: true, format: { with: CARD_EXPIRE_REGEX }, if: -> {$current_paymethod == "Credit Card"}
     validates :cvv,  presence: true, format: { with: CARD_CVV_REGEX }, if: -> {$current_paymethod == "Credit Card"}
     
     
     CARD_NUMBER_REGEX = /^[0-9]{16}/i
     CARD_NAME_REGEX = /^[a-z]+$/i
     CARD_EXPIRE_REGEX = /^[0-9]{2}/i
     CARD_CVV_REGEX = /^[0-9]{3}/i
end
