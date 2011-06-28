# -*- coding: utf-8 -*-
require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  context "The line_items controller" do
    setup do
      @item = Factory.create(:item)
      @user = Factory.create(:user)
      @trolley = @user.trolley
    end

    should "get index" do
      get :index, :item_id => @item.id
      assert_response :success
      assert_not_nil assigns(:line_items)
    end

    should "get new" do
      get :new, :item_id => @item.id
      assert_response :success
    end

    should "create line_item" do
      assert_difference('LineItem.count') do
        post :create, :line_item => {}, :item_id => @item.id, :user => @user.id
      end

      assert_redirected_to :controller => 'trolleys', :action => 'show', :user_id => @user.id
    end

    context "when there is an existing line_item" do
      setup do
        @order = @user.correct_order(@item)

        @line_item_1 = @item.line_items.create(:order => @order)
      end

      should "get index with a line_item" do
        get :index, :item_id => @item.id
        assert assigns(:line_items).size == 1
      end

      should "show line_item" do
        get :show, :id => @line_item_1.id, :item_id => @item.id
        assert_response :success
      end

      should "get edit" do
        get :edit, :id => @line_item_1.id, :item_id => @item.id
        assert_response :success
      end

      should "update line_item" do
        put :update, :id => @line_item_1.id, :item_id => @item.id, :line_item => { :order => Factory.create(:order) }
        assert_redirected_to :controller => 'trolleys', :action => 'show', :user_id => @user.id
      end

      should "destroy line_item" do
        assert_difference('LineItem.count', -1) do
          delete :destroy, :order_id => @order.id, :id => @line_item_1.id
        end

        assert_redirected_to :action => 'index', :order_id => @order.id
      end
    end
  end

end

