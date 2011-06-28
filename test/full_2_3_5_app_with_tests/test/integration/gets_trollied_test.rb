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
      visit "/items/#{@item.id}"
      assert_have_tag "input", :type => "submit", :value => I18n.t('gets_trollied_helper.add_to_trolley')
    end

    should "be able to submit add to trolley request and be added to trolley" do
      visit "/items/#{@item.id}"
      click_button "add to cart"
      assert_have_tag "title", :content => I18n.t('trolleys.show.your_title')
      assert_have_tag "a", :href => "/items/#{@item.id}", :content => @item.description_for_purchasing
    end

    # if an item has been placed in trolley previously, the add to trolley is replaced with link to trolley, and status of item shown
    should "after being added to a trolley, the object on its show page report that it is in the trolley, rather than providing the button to add to trolley" do
      @trolley = @user.trolley
      @trolley.add(@item)

      visit "/items/#{@item.id}"
      assert_have_tag "div", :content => I18n.t('gets_trollied_helper.in_trolley')
    end

  end
end
