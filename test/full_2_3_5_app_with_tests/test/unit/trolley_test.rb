# -*- coding: utf-8 -*-
require 'test_helper'

class TrolleyTest < ActiveSupport::TestCase
  context "A trolley" do
    setup do
      @item = Factory.create(:item)
    end

    context "when having an item placed in it" do
      should "result in a purchase order with a line_item for that item" do
        @trolley = Factory.create(:trolley)
        @trolley.add(@item)

        assert @trolley.purchase_order

        @purchase_order = @trolley.purchase_order

        assert_purchasable_item_matches
      end
    end
  end
end
