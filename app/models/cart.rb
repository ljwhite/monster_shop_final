class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    gt = 0.0
    @contents.each do |item_id, quantity|
    #  binding.pry
  #    grand_total += Item.find(item_id).price * quantity
  #    grand_total += item_price_including_discount(item_id) * quantity
      gt += self.subtotal_of(item_id.to_i)
    end
    gt
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
  #  @contents[item_id.to_s] * Item.find(item_id).price
  @contents[item_id.to_s] * item_price_including_discount(item_id)
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def find_best_discount
    discount_hash = Hash.new
    @contents.each do |item_id, qty|
      item = Item.find(item_id)
      merchant = Merchant.find(item.merchant_id)
      discounts_arr = merchant.discounts.select do |discount|
        discount.item_quantity <= qty
      end
      if discounts_arr.empty?
        discount_hash[item_id.to_i] = nil
      else
        best_discount = discounts_arr.max_by(&:discount_percentage)
        discount_hash[item_id.to_i] = best_discount
      end
    end
    discount_hash
  end

  def item_price_including_discount(item_id)
    discount_by_items = self.find_best_discount
    item_discount = discount_by_items[item_id]
    if item_discount.nil?
      price = Item.find(item_id).price
    else
      percentage = item_discount.discount_percentage / 100.0
      price = Item.find(item_id).price * (1-percentage)
    end
  end
end
