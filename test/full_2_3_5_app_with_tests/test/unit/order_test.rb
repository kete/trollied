# -*- coding: utf-8 -*-
require 'test_helper'

class PurchaseOrderTest < ActiveSupport::TestCase
  context "A purchase_order" do
    setup do
      @item = Factory.create(:item)
    end

    should "create a line_item when given an item" do
      @purchase_order = Factory.create(:purchase_order)
      
      @purchase_order.add(@item)
      
      assert_purchasable_item_matches
    end
  end
end
