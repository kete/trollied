# -*- coding: utf-8 -*-
require 'test_helper'

Webrat.configure do |config|
  config.mode = :rails
end

class TrolliedTest < ActionController::IntegrationTest
  context "A gets_trollied object" do
    include Webrat::HaveTagMatcher
    setup do
      @item = Factory.create(:item)
      @user = Factory.create(:user)
    end

    should "have an add to cart link on its show page" do
      visit "/items/1"
      assert_have_tag "input", :type => "submit", :value => I18n.t('gets_trollied_helper.add_to_cart')
    end

    # if an item has been placed in trolley previously, the add to cart is replaced with link to trolley, and status of item shown

    should "be able to submit add to cart request and be added to cart" do
      visit "/items/1"
      click_button "add to cart"
      assert_have_tag "title", :content => "Your Shopping Cart"
      assert_have_tag "a", :href => "/items/1", :content => "Item 1"
    end
  end
end
