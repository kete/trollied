# -*- coding: utf-8 -*-
require 'test_helper'

Webrat.configure do |config|
  config.mode = :rails
end

class OrderTest < ActionController::IntegrationTest
  include Webrat::HaveTagMatcher

  context "The orders index page" do

    context "when there are no orders on the site" do

      should "return message that there are currently no orders" do
        visit "/orders"
        assert_have_tag "p", :content => I18n.t('orders.index.no_orders')
      end
    end

    context "when there are orders" do
      setup do
        @item = Factory.create(:item)
        @order = Factory.create(:order)
        @item.place_in(@order.trolley)
      end
      
      context "that are current" do

        should "return message that there are no orders unless state = current" do
          visit "/orders"
          assert_have_tag "p", :content => I18n.t('orders.index.no_orders')
        end

        should "have link to view current orders" do
          visit "/orders"
          assert_have_tag "a", :content => I18n.t('orders.index.current')

          click_link I18n.t('orders.index.current')

          assert_have_tag "a", :content => @item.description_for_purchasing
        end
      end

      context "that are in_process" do
        setup do
          @order.checkout!
        end
        
        should "indicate that there are in_process orders and display them" do
          visit "/orders"
          assert_have_tag "li", :content => I18n.t('orders.index.in_process')
          assert_have_tag "a", :content => @item.description_for_purchasing
        end
      end

    end

    context "when a trolley is given" do
      setup do
        @trolley = Factory.create(:trolley)
      end

      context "when there are no orders in the trolley" do

        should "return message that there are currently no orders" do
          visit "/orders?trolley_id=#{@trolley.id}"
          assert_have_tag "p", :content => I18n.t('orders.index.no_orders')
        end
      end

      context "when there are orders" do

      end

    end

  end
end
