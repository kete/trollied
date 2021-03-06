# -*- coding: utf-8 -*-
require 'test_helper'

class OrdersHelperTest < ActionView::TestCase
  context "Helpers for orders" do

    should "respond to button_to event method for an order for all possible events" do
      Order.workflow_event_names.each do |event_name|
        assert respond_to?("button_to_#{event_name}")
      end
    end

    should "have show_count_for method that takes a number and returns formatted string" do
      assert_equal ' (2)', show_count_for(2)
    end

    should "have state_links that returns a list of links to order states" do
      @order1 = Factory.create(:order)
      @order1.checkout!

      @order2 = Factory.create(:order)
      @order2.checkout!
      @order2.cancel!

      @order3 = Factory.create(:order)

      @state = 'in_process' # default

      html = "<ul id=\"state-links\" class=\"horizontal-list\"><li class=\"state-link first\">#{I18n.t('orders.index.in_process')} (1)</li><li class=\"state-link\"><a href=\"/orders?state=cancelled\">#{I18n.t('orders.index.cancelled')} (1)</a></li><li class=\"state-link\"><a href=\"/orders?state=current\">#{I18n.t('orders.index.current')} (1)</a></li></ul>"

      assert_equal html, state_links
    end
  end
end
