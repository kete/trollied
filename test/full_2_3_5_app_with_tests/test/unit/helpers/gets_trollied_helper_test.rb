# -*- coding: utf-8 -*-
require 'test_helper'

class GetsTrolliedHelperTest < ActionView::TestCase
  include HasTrolleyControllerHelpers::UrlFor

  context "Helpers for stuff that gets trollied" do
    setup do
      @item = Factory.create(:item, :label => "a label")

      @form_fragment = "form method=\"post\" action=\"/items/1/line_items\""
      @input_fragment = "input type=\"submit\" value=\"+ Add to cart\""
      
      def current_user
        @current_user ||= User.first || Factory.create(:user)
      end
    end

    should "provide button_to_place_in_trolley that returns a form to add to cart for passed in purchasable_item" do
      assert_has_button_in(button_to_place_in_trolley(@item))
    end

    should "provide in_trolley_status_or_button_to_place_in_trolley that returns a form to add to cart for passed in purchasable_item when the item hasn't been added yet" do
      assert_has_button_in(in_trolley_status_or_button_to_place_in_trolley(@item))
    end

    context "should provide in_trolley_status_or_button_to_place_in_trolley that" do 
      setup do
        @trolley = current_user.trolley
        @trolley.add(@item)
      end

      should "return a statement that item is in user's trolley for passed in purchasable_item when has previously been added" do
        value = in_trolley_status_or_button_to_place_in_trolley(@item)

        assert value.include?("<div class=\"in-trolley\">" +
                              t('gets_trollied_helper.in_trolley') +
                              "</div>")

        assert_does_not_have_button_in(value)
      end

      context "when passed in purchasable_item has previously been added, but order has been checked out" do
        setup do
          @order = @trolley.selected_order
          @order.checkout!
        end

        should "return a statement that item is in user's trolley " do
          value = in_trolley_status_or_button_to_place_in_trolley(@item)
          assert_does_not_have_button_in(value)
        end

        should "return add to cart after the order has been moved to another state besides in_process" do
          @order.cancel!
          assert_has_button_in(in_trolley_status_or_button_to_place_in_trolley(@item))
        end
      end
    end

  end

  private

  def assert_has_button_in(value)
    assert value.include?(@form_fragment) &&
      value.include?(@input_fragment)
  end

  def assert_does_not_have_button_in(value)
    assert !value.include?(@form_fragment) &&
      !value.include?(@input_fragment)
  end

end
