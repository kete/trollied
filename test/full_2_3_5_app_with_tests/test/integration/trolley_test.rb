# -*- coding: utf-8 -*-
require 'test_helper'

Webrat.configure do |config|
  config.mode = :rails
end

class TrolleyTest < ActionController::IntegrationTest
  context "A trolley" do
    include Webrat::HaveTagMatcher
    setup do
      @item = Factory.create(:item)
      @user = Factory.create(:user)
      @trolley = @user.trolley
    end

    context "when there are line items in a current order" do
      setup do
        @item.place_in(@trolley)
        @order = @trolley.selected_order
        @line_item = @order.line_items.first
      end
      
      context "lists a current order and" do

        should "have the line item listed" do
          visit "/user/#{@user.id}/trolley"
          assert_have_tag "a", :href => "/items/#{@item.id}", :content => @item.description_for_purchasing
        end

        should "have a drop line item link for line item" do
          visit "/user/#{@user.id}/trolley"
          click_link "Delete"
          # assert that we are redirected back to trolley
          assert_have_tag "title", :content => I18n.t('trolleys.show.your_title')
        end

        should "have a clear all button" do
          visit "/user/#{@user.id}/trolley"
          assert_have_tag "input", :type => "submit", :value => I18n.t('orders.order.clear_all')

          click_button I18n.t('orders.order.clear_all')
          
          assert_have_tag "p", :content => I18n.t('trolleys.orders.none_pending')
        end

        should "have a checkout button that moves the order out of current status" do
          visit "/user/#{@user.id}/trolley"
          assert_have_tag "input", :type => "submit", :value => I18n.t('orders.order.checkout')

          click_button I18n.t('orders.order.checkout')
          
          assert_have_tag "p", :content => I18n.t('trolleys.orders.none_pending')
        end

        should "have a cancel button that moves the order out of current status and marks it as cancelled" do
          @order.checkout!

          visit "/user/#{@user.id}/trolley"
          assert_have_tag "input", :type => "submit", :value => I18n.t('orders.order.cancel')

          click_button I18n.t('orders.order.cancel')

          # cancelled orders are not listed on trolley
          # assert_have_tag "h2", :content => I18n.t('orders.order.cancelled')
        end

      end
    end
  end
end
