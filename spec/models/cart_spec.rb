require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 2 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @cart = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
      @discount1 = Discount.create!(name: "Winter Sale", item_quantity: 1, discount_percentage: 5, merchant: @megan)
      @discount2 = Discount.create!(name: "Spring Sale", item_quantity: 2, discount_percentage: 10, merchant: @megan)
    end

    it '.contents' do
      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    it '.add_item()' do
      @cart.add_item(@hippo.id.to_s)

      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2,
        @hippo.id.to_s => 1
        })
    end

    it '.count' do
      expect(@cart.count).to eq(3)
    end

    it '.items' do
      expect(@cart.items).to eq([@ogre, @giant])
    end

    it '.grand_total' do
      expect(@cart.subtotal_of(@ogre.id)).to eq(19)
    #  expect(@cart.grand_total).to eq(120)
      expect(@cart.grand_total).to eq(109.0)
    end

    it '.count_of()' do
      expect(@cart.count_of(@ogre.id)).to eq(1)
      expect(@cart.count_of(@giant.id)).to eq(2)
    end

    it '.subtotal_of()' do
      # expect(@cart.subtotal_of(@ogre.id)).to eq(20)
      # expect(@cart.subtotal_of(@giant.id)).to eq(100)
      expect(@cart.subtotal_of(@ogre.id)).to eq(19)
      expect(@cart.subtotal_of(@giant.id)).to eq(90)
    end

    it '.limit_reached?()' do
      expect(@cart.limit_reached?(@ogre.id)).to eq(false)
      expect(@cart.limit_reached?(@giant.id)).to eq(true)
    end

    it '.less_item()' do
      @cart.less_item(@giant.id.to_s)
      expect(@cart.count_of(@giant.id)).to eq(1)
    end

    it '.find_best_discount' do
      @cart.add_item(@hippo.id.to_s)
      @cart.add_item(@hippo.id.to_s)

      expect(@cart.find_best_discount).to eq({@ogre.id => @discount1,
                                              @giant.id => @discount2,
                                              @hippo.id => nil})
    end

    it ".item_price_including_discount" do
      @cart.add_item(@hippo.id.to_s)
      expect(@cart.item_price_including_discount(@ogre.id)).to eq(19)
      expect(@cart.item_price_including_discount(@giant.id)).to eq(45)
      expect(@cart.item_price_including_discount(@hippo.id)).to eq(50)
    end

  end
end
