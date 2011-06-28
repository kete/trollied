class PurchaseOrdersController < ApplicationController
  # Prevents the following error from showing up, common in Rails engines
  # A copy of ApplicationController has been removed from the module tree but is still active!
  unloadable

  before_filter :get_trolley
  before_filter :get_purchase_order, :except => [:new, :index, :create]

  # GET /purchase_orders
  # GET /purchase_orders.xml
  def index
    if @trolley
      @purchase_orders = @trolley.purchase_orders
    else
      # site wide
      # TODO: add permission check of admin mechanism
      # TODO: add pagination
      @purchase_orders = nil
    end

    respond_to do |format|
      format.html # index.html.erb
      # format.xml  { render :xml => @line_items }
    end
  end

  # GET /purchase_orders/1
  # GET /purchase_orders/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      # format.xml  { render :xml => @line_item }
    end
  end

  # GET /purchase_orders/new
  # GET /purchase_orders/new.xml
  def new
    @trolley ||= current_user ? current_user.trolley : raise # trolley not found
    
    @trolley.purchase_orders.new

    respond_to do |format|
      format.html # new.html.erb
      # format.js { render :layout => false } # needs to come after html for IE to work
      # format.xml  { render :xml => @line_item }
    end
  end

  # GET /purchase_orders/1/edit
  def edit
  end

  # POST /purchase_orders
  # POST /purchase_orders.xml
  def create
    purchase_order_params = params[:purchase_order] || params[:trolley_purchase_order] || Hash.new

    @purchase_order = @trolley.purchase_orders.new(purchase_order_params) 

    respond_to do |format|
      if @purchase_order.save
        flash[:notice] = t('purchase_orders.controllers.created')
        # we redirect to purchasable_item object in the new purchasable_item version
        # assumes controller name is tableized version of class
        format.html { redirect_to url_for_trolley }
        # TODO: adjust :location accordingly for being a nested route
        # format.xml  { render :xml => @line_item, :status => :created, :location => @line_item }
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @line_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /purchase_orders/1
  # PUT /purchase_orders/1.xml
  def update
    respond_to do |format|
      purchase_order_params = params[:purchase_order] || params[:trolley_purchase_order]
      if @purchase_order.update_attributes(purchase_order_params)
        flash[:notice] = t('purchase_orders.controllers.updated')
        format.html { redirect_to @purchase_order }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @line_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_orders/1
  # DELETE /purchase_orders/1.xml
  def destroy
    return_to = @trolley ? url_for_trolley : { :action => :index }
    @purchase_order.destroy

    respond_to do |format|
      flash[:notice] = t('purchase_orders.controllers.deleted')
      format.html { redirect_to return_to }
      # format.xml  { head :ok }
    end
  end

  protected
  # accepts line_item.locale or line_item.id for lookup
  # line_item.locale should be unique within the scope of @purchasable_item
  def get_purchase_order
    @purchase_order = if @trolley
                        if params[:id].present?
                          @trolley.purchase_orders.find(params[:id])
                        else
                          @trolley.purchase_order
                        end
                      elsif params[:id].present?
                        PurchaseOrder.find(params[:id])
                      end
  end

  def get_trolley
    @trolley = params[:trolley_id].present? ? Trolley.find(params[:trolley_id]) : nil
  end
end
