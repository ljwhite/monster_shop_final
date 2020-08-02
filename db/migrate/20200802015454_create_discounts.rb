class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :name
      t.integer :item_quantity
      t.integer :discount_percentage
    end
  end
end
