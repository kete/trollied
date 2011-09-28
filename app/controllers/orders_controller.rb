class OrdersController < ApplicationController
  # Prevents the following error from showing up, common in Rails engines
  # A copy of ApplicationController has been removed from the module tree but is still active!
  unloadable

  before_filter :get_user, :only => [:index]
  before_filter :get_trolley
  before_filter :get_order, :except => [:new, :index, :create]

  # GET /orders
  # GET /orders.xml
   def index
     # TODO: add permission check of admin mechanism

     # 'all' will return what you expect, i.e. orders for all states
     # other valid values are specific state names
     # default should be set depending on rights of current_user
     # we'll start with an assumption of staff view
     # as a user's trolley lists their own current orders by default
     @state = params[:state].present? ? params[:state] : 'in_process'
     params[:state] = @state

     @conditions = set_up_conditions_based_on_params

     options = { :page => params[:page],
       :per_page => number_per_page,
       :conditions => @conditions, 
       :order => 'updated_at DESC'}

     @orders = Order.paginate(options)

     respond_to do |format|
       format.html # index.html.erb
       # format.xml  { render :xml => @line_items }
     end
   end

   # GET /orders/1
   # GET /orders/1.xml
   def show
     respond_to do |format|
       format.html # show.html.erb
       # format.xml  { render :xml => @line_item }
     end
   end

   # GET /orders/new
   # GET /orders/new.xml
   def new
     @trolley ||= current_user ? current_user.trolley : raise # trolley not found

     @trolley.orders.new

     respond_to do |format|
       format.html # new.html.erb
       # format.js { render :layout => false } # needs to come after html for IE to work
       # format.xml  { render :xml => @line_item }
     end
   end

   # GET /orders/1/edit
   def edit
   end

   # POST /orders
   # POST /orders.xml
   def create
     order_params = params[:order] || params[:trolley_order] || Hash.new

     @order = @trolley.orders.new(order_params) 

     respond_to do |format|
       if @order.save
         flash[:notice] = t('orders.controllers.created')
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

   # PUT /orders/1
   # PUT /orders/1.xml
   def update
     respond_to do |format|
       order_params = params[:order] || params[:trolley_order]
       if @order.update_attributes(order_params)
         flash[:notice] = t('orders.controllers.updated')
         format.html { redirect_to @order }
         # format.xml  { head :ok }
       else
         format.html { render :action => "edit" }
         # format.xml  { render :xml => @line_item.errors, :status => :unprocessable_entity }
       end
     end
   end

   # DELETE /orders/1
   # DELETE /orders/1.xml
   def destroy
     @trolley ||= @order.trolley
     return_to = @trolley ? url_for_trolley : { :action => :index }

     @order.destroy

     respond_to do |format|
       flash[:notice] = t('orders.controllers.deleted')
       format.html { redirect_to return_to }
       # format.xml  { head :ok }
     end
   end

   # optional checkout form
   # that can be used for simple per order settings or allowing the user to add a note
   def checkout_form
     set_defaults_for_order_checkout
     @order.notes.build unless @order.notes.any?
   end

   def checkout
     respond_to do |format|
       if checkout_order_including_note
         @trolley ||= @order.trolley
         flash[:notice] = t("orders.controllers.change_to_checkout")
         format.html { redirect_to url_for_trolley }
       else
         # display errors
         format.html { render :action => "checkout_form" }
       end
     end
   end

   # additional actions that correspond to order_status events
   %w(cancel alteration_approve fulfilled_without_acceptance finish).each do |event|
     code = Proc.new { 
       if event == 'cancel'
         @order.send("#{event}!", current_user)
       else
         @order.send("#{event}!")
       end

       @trolley ||= @order.trolley

       flash[:notice] = t("orders.controllers.change_to_#{event}")
       redirect_to url_for_trolley
     }

     define_method(event, &code)
   end

   private
   # accepts line_item.locale or line_item.id for lookup
   # line_item.locale should be unique within the scope of @purchasable_item
   def get_order
     @order = if @trolley
                         if params[:id].present?
                           @trolley.orders.find(params[:id])
                         else
                           @trolley.selected_order
                         end
                       elsif params[:id].present?
                         Order.find(params[:id])
                       end
   end

   def get_trolley
     @trolley = if params[:trolley_id].present?
                  Trolley.find(params[:trolley_id])
                elsif @user
                  @user.trolley
                end
   end

   def get_user
     @user = if params[:user_id].present? || params[:user].present?
               id = params[:user_id].present? ? params[:user_id] : params[:user]
               User.find(id)
             end
   end

   # validate and add them as conditions
   def add_date_clause_and_var_for(name, clauses_array, clauses_hash)
     if params[name].present?
       value = params[name]
       var_name = "@" + name.to_s

       instance_variable_set(var_name, value)

       begin
         Date.parse(value)
         operator = ">="
         operator = "<=" if name == :until

         clauses_array << "updated_at #{operator} :#{name}"
         clauses_hash[name] = value
       rescue
         instance_variable_set(var_name, nil)
       end
     end
   end

   def default_conditions_hash
     { :workflow_state => @state }
   end

   def set_up_conditions_based_on_params
     conditions_clauses = Array.new
     conditions_hash = default_conditions_hash

     # handle date range
     add_date_clause_and_var_for(:from, conditions_clauses, conditions_hash)
     add_date_clause_and_var_for(:until, conditions_clauses, conditions_hash)

     # user is a little funnier because trolley is what has the direct user relation
     # so trolley is really what will give us a user's orders
     conditions_hash[:trolley_id] = @trolley.id if @trolley

     if conditions_clauses.size > 0
       conditions_hash.each do |k,v|
         conditions_clauses << "#{k} = :#{k}" unless conditions_clauses.join.include?(':' + k.to_s)
       end
     end

     conditions = if conditions_clauses.size == 0
                    conditions_hash
                  else
                    [conditions_clauses.join(" AND "), conditions_hash]
                  end
     
   end

   # override this if your additional attributes need calculation for defaults at checkout
   def set_defaults_for_order_checkout
   end

   def checkout_order_including_note
     # skip alerting the order (triggering a duplicate notification) that a new_note has been added
     # assumes only one note in form
     if params[:order][:notes_attributes].present?
       params[:order][:notes_attributes]["0"][:do_not_alert_order] = true

       if params[:order][:notes_attributes]["0"][:body].blank?
         # don't add empty note
         params[:order].delete(:notes_attributes)
       end
     end

     # this will add note and any attributes you have in the checkout form for order
     success = @order.update_attributes(params[:order])

     if success
       # we have to call checkout! separately to trigger event notifications
       @order.checkout!
     end
     success
   end

   def number_per_page
     15
   end
end
