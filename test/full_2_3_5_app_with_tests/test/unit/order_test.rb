# -*- coding: utf-8 -*-
require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  context "An order" do
    setup do
      @item = Factory.create(:item)
      @order = Factory.create(:order)
    end

    context "class" do

      context "have a named scope 'in' that takes a state as an argument" do
        should "return all orders if 'all' is the special case argument" do
          assert_equal @order, Order.in('all').first
          @order.checkout!
          assert_equal @order, Order.in('all').first
        end

        should "return orders in that state" do
          @order.checkout!
          assert_equal @order, Order.in('in_process').first
        end
      end
    end

    should "have a user through its trolley's user" do
      assert_equal @order.trolley.user, @order.user
    end

    # test that we have integration with the workflow gem
    should "have a workflow_state and the default is current" do
      assert_equal 'current', @order.workflow_state
    end

    should "have a current_state" do
      assert @order.respond_to?(:current_state)
    end

    should "transition to in_process when checked out" do
      @order.checkout!
      # assert @order.ordered?
      assert @order.in_process?
    end

    context "after adding an item to it" do
      setup do
        @order.add(@item)
      end

      should "create a line_item with the item" do
        assert_purchasable_item_matches
      end

      should "return true when it contains an item" do
        assert @order.contains?(@item)
      end
    end

    should "return false when it does not contain an item" do
      assert @order.contains?(@item) == false
    end

  end
end
