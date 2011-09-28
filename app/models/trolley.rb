class Trolley < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  # get specified order (or first, if not specified)
  # or create one if none exists
  def selected_order(position = 1)
    index = position - 1
    
    orders[index] || orders.create!
  end

  # correct order given an purchasable_item
  def correct_order(purchasable_item)
    orders.with_state_current.first || orders.create!
  end

  # add item or array of items to trolley
  def add(*items_to_order)
    # get order
    items_to_order.each do |item|
      selected_order.add(item)
    end
  end

  # do any of this trolley's orders contain the purchasable_item?
  def contains?(purchasable_item, state = nil)
    within_orders = state ? orders.send("with_state_#{state}") : orders

    these_contain?(within_orders, purchasable_item)
  end

  def these_contain?(within_orders, purchasable_item)
    return false if within_orders.size == 0

    within_orders.each do |order|
      return true if order.contains?(purchasable_item)
    end
    false
  end

  # active is defined as either current or in_process order
  def has_active_order_for?(purchasable_item)
    within_orders = orders.with_state_current + orders.with_state_in_process + orders.with_state_ready

    these_contain?(within_orders, purchasable_item)
  end

end
