class NotesController < ApplicationController
  # Prevents the following error from showing up, common in Rails engines
  # A copy of ApplicationController has been removed from the module tree but is still active!
  unloadable

  before_filter :get_order
  before_filter :get_note, :except => [:new, :index, :create]

  # GET /notes
  # GET /notes.xml
  def index
    # TODO: add permission check of admin mechanism
    # TODO: add pagination

    @notes = @order.notes

    respond_to do |format|
      format.html # index.html.erb
      # format.xml  { render :xml => @line_items }
    end
  end

  # GET /notes/1
  # GET /notes/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      # format.xml  { render :xml => @line_item }
    end
  end

  # GET /notes/new
  # GET /notes/new.xml
  def new
    @order.notes.new

    respond_to do |format|
      format.html # new.html.erb
      # format.js { render :layout => false } # needs to come after html for IE to work
      # format.xml  { render :xml => @line_item }
    end
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  # POST /notes.xml
  def create
    note_params = params[:note] || params[:order_note] || Hash.new

    @note = @order.notes.new(note_params) 

    respond_to do |format|
      if @note.save
        flash[:notice] = t('notes.controllers.created')
        # we redirect to purchasable_item object in the new purchasable_item version
        # assumes controller name is tableized version of class
        format.html { redirect_to url_for_order_or_trolley }
        # TODO: adjust :location accordingly for being a nested route
        # format.xml  { render :xml => @line_item, :status => :created, :location => @line_item }
      else
        format.html { render :action => "new" }
        # format.xml  { render :xml => @line_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.xml
  def update
    respond_to do |format|
      note_params = params[:note] || params[:order_note]
      if @note.update_attributes(note_params)
        flash[:notice] = t('notes.controllers.updated')
        format.html { redirect_to url_for_order_or_trolley }
        # format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        # format.xml  { render :xml => @line_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.xml
  def destroy
    @order ||= @note.order
    return_to = @order ? url_for_order_or_trolley : { :action => :index }

    @note.destroy

    respond_to do |format|
      flash[:notice] = t('notes.controllers.deleted')
      format.html { redirect_to return_to }
      # format.xml  { head :ok }
    end
  end

  protected

  def get_note
    @note ||= if @order
              if params[:id].present?
                @order.notes.find(params[:id])
              end
            elsif params[:id].present?
              Note.find(params[:id])
            end
  end

  def get_order
    @order = if params[:order_id].present?
               Order.find(params[:order_id])
             elsif params[:id].present?
               @note = Note.find(params[:id]) 
               @note.order
             end
  end
end
