class PurchaseOrder < ActiveRecord::Base
  belongs_to :trolley
  has_many :line_items

  # has user by its relation to trolley

  # convenience method to add new line item based on item_to_order
  def add(purchasable_item)
    line_items.create!(:purchasable_item => purchasable_item)
  end

end
