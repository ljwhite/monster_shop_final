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

    it "on the discount index page, there is a link to delete a merchant discount" do
      visit "/merchant/discounts"

      within("#discount-#{@discount1.id}") do
        expect(page).to have_link("Delete")
      end
    end

    it "clicking on that link will return you to the merchant discount index page. A flash message will indicate that the discount has been deleted, and the deleted discount will not be in the index list" do
      visit "/merchant/discounts"

      within("#discount-#{@discount1.id}") do
        click_on "Delete"
      end

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("#{@discount1.name} has been deleted")
      expect(page).to_not have_css("#discount-#{@discount1.id}")
      expect(page).to have_css("#discount-#{@discount2.id}")
    end


  end
end
