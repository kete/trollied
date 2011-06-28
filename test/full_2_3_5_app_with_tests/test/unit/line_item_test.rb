# -*- coding: utf-8 -*-
require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  context "A line_item" do
    setup do
      @item = Factory.create(:item)

      @order = Factory.create(:order)
      
      @order.add(@item)

      @line_item = @order.line_items.first
    end

    should "have a user through its order's user" do
      assert_equal @order.user, @line_item.user
    end

    should "have a  description_for_purchasing method" do
      assert_respond_to @line_item, :description_for_purchasing
    end

    should "return the purchasable_item's purchase_description as delegated" do
      assert_equal @item.description_for_purchasing, @line_item.description_for_purchasing
    end
  end
end
