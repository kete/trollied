# -*- coding: utf-8 -*-
require 'test_helper'

class TrolleyTest < ActiveSupport::TestCase
  context "A trolley" do
    setup do
      @item = Factory.create(:item)
      @trolley = Factory.create(:trolley)
    end
    
    context "when having an item placed in it" do
      setup do
        @trolley.add(@item)
        @order = @trolley.selected_order
      end

      should "result in an order with a line_item for that item" do
        assert_purchasable_item_matches
      end

      should "answer true for contains? method" do
        assert @trolley.contains?(@item)
      end

      should "return true for has_active_order_for? purchasable_item" do
        assert @trolley.has_active_order_for?(@item)
      end

      context "and the item has already been placed in trolley, but first order has been checked out" do 
        setup do
          @order.checkout!
        end

        should "answer false for contains? method when current state specified" do
          assert @trolley.contains?(@item, :current) == false
        end

        should "answer true for contains? method when the item is in order with a given state" do
          assert @trolley.contains?(@item, :in_process)
        end

        should "have correct_order be an order that is current, not in_process order" do
          correct_order = @trolley.correct_order(@item)
          assert correct_order != @order
          assert correct_order.current?
        end

        should "return true for has_active_order_for? purchasable_item" do
          assert @trolley.has_active_order_for?(@item)
        end

        context "and the order is then moved from in_process" do
          should "return false for has_active_order_for? purchasable_item" do
            @order.cancel!
            assert !@trolley.has_active_order_for?(@item)
          end
        end

      end

    end

    context "when an item is not in a trolley" do
      should "answer false for contains? method" do
        assert @trolley.contains?(@item) == false
      end

      should "answer false for contains? method even if there is an order for the trolley" do
        @trolley.selected_order
        
        assert @trolley.contains?(@item) == false
      end

      should "return false for has_active_order_for? purchasable_item" do
        assert !@trolley.has_active_order_for?(@item)
      end
    end

  end
end
