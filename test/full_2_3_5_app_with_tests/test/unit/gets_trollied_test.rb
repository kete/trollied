# -*- coding: utf-8 -*-
require 'test_helper'

class GetsTrolliedTest < ActiveSupport::TestCase
  context "A model that can be trollied" do
    setup do
      @item = Factory.create(:item)
    end

    should "be able to be added to a trolley" do
      @trolley = Factory.create(:trolley)
      @item.place_in(@trolley)

      assert @trolley.selected_order

      @order = @trolley.selected_order

      assert_purchasable_item_matches
    end

    should "answer description_for_purchasing" do
      assert_respond_to @item, :description_for_purchasing
    end

    should "return mapped attribute value from description_for_purchasing" do
      assert_equal @item.label, @item.description_for_purchasing
    end
  end
end
