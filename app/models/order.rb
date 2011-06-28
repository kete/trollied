class Order < ActiveRecord::Base
  belongs_to :trolley
  has_many :line_items, :dependent => :destroy
  has_many :notes, :dependent => :destroy

  # has user by its relation to trolley
  delegate :user, :to => :trolley

  include OrderStatus
  
  # convenience method to add new line item based on item_to_order
  def add(purchasable_item)
    line_items.create!(:purchasable_item => purchasable_item)
  end

  # do any of this order's line_items contain the purchasable_item?
  def contains?(purchasable_item)
    return false if line_items.size == 0
    
    line_items.each do |line_item|
      return true if line_item.purchasable_item == purchasable_item
    end
    false
  end

  def may_note?
    in_process? || ready? || user_review?
  end
end
