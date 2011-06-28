# -*- coding: utf-8 -*-
require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  context "A note" do
    setup do
      @order = Factory.create(:order)
    end

    should "be able to be created for an order" do
      assert_nothing_raised { @order.notes.create!(:body => "a test note", :user => User.first) }
    end
  end
end
