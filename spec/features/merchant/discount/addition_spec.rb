require 'rails_helper'

RSpec.describe 'As a merchant employee' do
  describe 'on the merchant dashboard' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
      @customer  = User.create!(name: "Tim", address: '456 Fleet Street', city: "Denver", state: 'CO', zip: 80204, email: 'email@gmail.com', password: 'password', role: 0)

      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'I can click a link to create a discount' do
      visit "/merchant"

      click_link 'Create Discount'

      expect(current_path).to eq("/merchant/discounts/new")
    end

    it "I can create a discount for a merchant" do
      name = "Christmas Discount"
      item_quantity = 5
      percentage = 20

      visit 'merchant/discounts/new'

      fill_in 'Name', with: name
      fill_in 'item_quantity', with: item_quantity
      fill_in 'discount_percentage', with: percentage
      click_on "Create Discount"
      expect(current_path).to eq("/merchant/discounts")
      new_discount = Discount.last
      expect(new_discount.name).to eq(name)
      expect(new_discount.item_quantity).to eq(item_quantity)
      expect(new_discount.discount_percentage).to eq(percentage)
      expect(page).to have_content("Added #{new_discount.name} to discounts")
    end

    it 'The discount is not created if the item_quantity and discount_percentage is not filled out. A flash error will result.' do
      name = "Christmas Discount"
      item_quantity = 5
      percentage = 20

      visit 'merchant/discounts/new'

      fill_in 'Name', with: name
      #fill_in 'item_quantity', with: item_quantity
      fill_in 'discount_percentage', with: percentage
      click_on "Create Discount"
      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("Required item quantity")
    end

  end
end
