class TrolleysController < ApplicationController
  # Prevents the following error from showing up, common in Rails engines
  # A copy of ApplicationController has been removed from the module tree but is still active!
  unloadable

  before_filter :get_trollied_user
  before_filter :get_trolley

  # list orders
  def show
    respond_to do |format|
      format.html
    end
  end
  
  protected

  def get_trollied_user
    @trollied_user = User.find(params[:user_id])
  end

  def get_trolley
    @trolley = @trollied_user.trolley
  end

end
