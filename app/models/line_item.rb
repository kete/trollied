class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :purchasable_item, :polymorphic => true

  delegate :description_for_purchasing, :to => :purchasable_item

  delegate :user, :to => :order

  # this is deprecated in Rails 3x, find workaround
  # an observer seemed like overkill and would have 3x compatibility stuff todo anyway
  after_destroy { |record| record.order.line_item_destroyed }

  # needs to be unique to orders that are current (but not unique to orders generally)
  validates_uniqueness_of :order_id, :scope => [:purchasable_item_type, :purchasable_item_id]

  def validate
    errors.add(:order, I18n.t('line_item.already_in_order')) if !order.current? && !order.in_process? && order.contains?(purchasable_item)
  end
end
