# -*- coding: utf-8 -*-
require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  context "A line_item" do
    setup do
      @item = Factory.create(:item)

      @purchase_order = Factory.create(:purchase_order)
      
      @purchase_order.add(@item)

      @line_item = @purchase_order.line_items.first
    end

    should "have a  description_for_purchasing method" do
      assert_respond_to @line_item, :description_for_purchasing
    end

    should "return the purchasable_item's purchase_description as delegated" do
      assert_equal @item.description_for_purchasing, @line_item.description_for_purchasing
    end
  end
end
