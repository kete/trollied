class LineItem < ActiveRecord::Base
  belongs_to :purchase_order
  belongs_to :purchasable_item, :polymorphic => true

  delegate :description_for_purchasing, :to => :purchasable_item

  validates_uniqueness_of :purchase_order_id, :scope => [:purchasable_item_type, :purchasable_item_id]
end
