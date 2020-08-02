require 'rails_helper'

RSpec.describe 'As a merchant employee' do
  describe 'on the merchant dashboard' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
      @customer  = User.create!(name: "Tim", address: '456 Fleet Street', city: "Denver", state: 'CO', zip: 80204, email: 'email@gmail.com', password: 'password', role: 0)

      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )

      @discount1 = Discount.create!(name: "Spring Sale", item_quantity: 10, discount_percentage: 10, merchant: @merchant_1)
      @discount2 = Discount.create!(name: "Back to School", item_quantity: 20, discount_percentage: 15, merchant: @merchant_1)
      @discount3 = Discount.create!(name: "Store Liquidation", item_quantity: 50, discount_percentage: 50, merchant: @merchant_1)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "on the merchant discount index page there is a link next to each discount allowing me to edit that discount" do
      visit "/merchant/discounts"
      within("#discount-#{@discount1.id}") do
        expect(page).to have_link("Edit")
      end
    end

    it "clicking on the link takes me to a form, where I can edit the name, item quantity, and discount percentage. Upon form submission, I am taken back to the index page, and the updated discount is shown, along with a flash message indicating the update was successful" do
      name = "Fall Price Fall"
      item_quantity = 100
      discount_percentage = 60
      visit "/merchant/discounts/#{@discount1.id}/edit"
      fill_in 'Name', with: name
      fill_in 'item_quantity', with: item_quantity
      fill_in 'discount_percentage', with: discount_percentage
      click_on "Update Discount"
      new_discount = Discount.last
      expect(page).to have_content("Discount has been updated")
      within("#discount-#{new_discount.id}") do
        expect(page).to have_content(new_discount.name)
        expect(page).to have_content(new_discount.item_quantity)
        expect(page).to have_content(new_discount.discount_percentage)
      end
    end

    it "if I do not correctly fill out the form, I am taken back to the edit form to try again" do
      name = "Fall Price Fail"
      item_quantity = 100
      discount_percentage = 60
      visit "/merchant/discounts/#{@discount1.id}/edit"
      fill_in 'Name', with: name
      fill_in 'item_quantity', with: ""
      fill_in 'discount_percentage', with: discount_percentage
      click_on "Update Discount"
      
      expect(page).to have_content("Item quantity can't be blank")
    end

  end
end
