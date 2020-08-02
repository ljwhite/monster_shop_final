class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :item_quantity, :discount_percentage
end
