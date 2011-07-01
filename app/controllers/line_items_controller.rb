class LineItemsController < ApplicationController
  # Prevents the following error from showing up, common in Rails engines
  # A copy of ApplicationController has been removed from the module tree but is still active!
  unloadable

  before_filter :get_order, :only => [:index, :destroy]
  before_filter :get_purchasable_item_key_and_class
  before_filter :get_purchasable_item
  before_filter :get_user
  before_filter :get_line_item, :except => [:new, :index, :create]

  # GET /line_items
  # GET /line_items.xml
  def index
    @line_items = @order ? @order.line_items : @purchasable_item.line_items

    respond_to do |format|
      format.html # index.html.erb
      # format.xml  { render :xml => @line_items }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      # format.xml  { render :xml => @line_item }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.xml
  def new
    @line_item = @purchasable_item.line_items.new

    respond_to do |format|
      format.html # new.html.erb
      # format.js { render :layout => false } # needs to come after html for IE to work
      # format.xml  { render :xml => @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.xml
  def create
    line_item_params = params[:line_item] || params[@purchasable_item_params_name + '_line_item'] || Hash.new

    @order = @user.correct_order(@purchasable_item)

    @trolley = @order.trolley

    line_item_params[:order] = @order

    @line_item = @purchasable_item.line_items.new(line_item_params) 

    respond_to do |format|
      if @line_item.save
        flash[:notice] = t('line_items.controllers.created')
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

  # PUT /line_items/1
  # PUT /line_items/1.xml
  def update
    respond_to do |format|
      line_item_params = params[:line_item] || params[@purchasable_item_params_name + '_line_item']
      if @line_item.update_attributes(line_item_params)
        flash[:notice] = t('line_items.controllers.updated')
        format.html { redirect_to url_for_trolley }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @line_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.xml
  def destroy
    return_to = if @order && @order.line_items.size > 1
                  url_for_order
                elsif params[:return_to_purchasable_item].present? && params[:return_to_purchasable_item]
                  url_for_purchasable_item
                elsif params[:trolley_id].present?
                  @trolley = Trolley.find(params[:trolley_id])
                  url_for_trolley
                else 
                  { :action => :index }
                end

    @line_item.destroy

    respond_to do |format|
      flash[:notice] = t('line_items.controllers.deleted')
      format.html { redirect_to return_to }
      # format.xml  { head :ok }
    end
  end

  protected
  # accepts line_item.locale or line_item.id for lookup
  # line_item.locale should be unique within the scope of @purchasable_item
  def get_line_item
    @line_item ||= @purchasable_item.line_items.find(params[:id])
  end

  def get_purchasable_item
    @purchasable_item ||= @purchasable_item_class.present? ? @purchasable_item_class.find(params[@purchasable_item_key]) : nil
  end

  # TODO: allow passing in user_id, but after permission check?
  def get_user
    # @user = params[:user].present? ? User.find(params[:user]) : current_user
    @user = current_user
  end

  def get_order
    @order = params[:order_id].present? ? Order.find(params[:order_id]) : nil
  end

  # assuming nested routing under purchasable_item controller, this should return exactly one params key
  # and its matching class
  # if it is nested routing under orders controller, this should get order
  # and if params[:id] is present, get line item, etc.
  # however, if order is present, but params[:id] is not, other instance variables will not be set
  def get_purchasable_item_key_and_class
    if @order && params[:id]
      @line_item = @order.line_items.find(params[:id])
      @purchasable_item = @line_item.purchasable_item
      @purchasable_item_class = @purchasable_item.class
      @purchasable_item_key = @purchasable_item.class.as_foreign_key_sym
      @purchasable_item_params_name = @purchasable_item_key.to_s.sub('_id', '')
    else
      purchasable_item_keys = params.keys.select { |key| key.to_s.include?('_id') }

      purchasable_item_keys.each do |key|
        key = key.to_s
        if key != 'line_item_id' && request
          key_singular = key.sub('_id', '')

          # make sure this is found in the request url
          # thus making this a nested route
          # assumes plural version for controller name
          # TODO: make this assumption overridable
          if request.path.split('/').include?(key_singular.pluralize)
            @purchasable_item_class = key_singular.camelize.constantize
            @purchasable_item_key = key.to_sym
            @purchasable_item_params_name = key_singular
            break
          end
        end
      end
    end
  end
end
