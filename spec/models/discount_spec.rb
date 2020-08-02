require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'validations' do
    it {should validate_presence_of :item_quantity}
    it {should validate_presence_of :discount_percentage}
  end

  describe 'relationships' do
    it {should belong_to :merchant}
  end
end
