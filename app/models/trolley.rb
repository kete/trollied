class Trolley < ActiveRecord::Base
  belongs_to :user
  has_many :purchase_orders

  # get specified purchase_order (or first, if not specified)
  # or create one if none exists
  def purchase_order(position = 1)
    index = position - 1
    
    purchase_orders[index] || purchase_orders.create!
  end

  # TODO: STUB: implement way to determine
  # correct purchase_order given an purchasable_item
  def correct_purchase_order(purchasable_item)
    purchase_order
  end

  # add item or array of items to trolley
  def add(*items_to_order)
    # get purchase_order
    items_to_order.each do |item|
      purchase_order.add(item)
    end
  end
end
