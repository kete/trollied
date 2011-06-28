# -*- coding: utf-8 -*-
require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  context "The orders controller" do
    setup do
      @item = Factory.create(:item)
      @user = Factory.create(:user)
      @trolley = @user.trolley
    end

    should "get index" do
      get :index, :trolley_id => @trolley.id, :user_id => @user.id
      assert_response :success
      assert_not_nil assigns(:orders)
    end

    should "get new" do
      get :new, :trolley_id => @trolley.id, :user_id => @user.id
      assert_response :success
    end

    should "create order" do
      assert_difference('Order.count') do
        post :create, :order => {}, :user_id => @user.id
      end

      assert_redirected_to :controller => 'trolleys', :action => 'show', :user_id => @user.id
    end

    context "when there is an existing order" do
      setup do
        @order = @user.correct_order(@item)

        @line_item_1 = @item.line_items.create(:order => @order)
      end

      should "be able to checkout order" do
        post :checkout, :id => @order.id, :trolley_id => @order.trolley.id

        assert_redirected_to :controller => 'trolleys', :action => 'show', :user_id => @user.id
      end

#       should "get index with a order" do
#         get :index, :trolley_id => @trolley.id, :user_id => @user.id
#         assert assigns(:orders).size == 1
#       end

#       should "show order" do
#         get :show, :id => @order.id
#         assert_response :success
#       end

#       should "get edit" do
#         get :edit, :id => @order.id
#         assert_response :success
#       end

#       should "update order" do
#         put :update, :id => @order.id, :order => { :order => Factory.create(:order) }
#         assert_redirected_to :controller => 'trolleys', :action => 'show', :user_id => @user.id
#       end

#       should "destroy order" do
#         assert_difference('Order.count', -1) do
#           delete :destroy, :id => @order_1.id
#         end

#         assert_redirected_to :controller => 'trolleys', :action => 'show', :user_id => @user.id
#       end
    end
  end

end

