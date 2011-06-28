# simple model for adding notes by either staff or ordering user to an order
# note is body attribute
class Note < ActiveRecord::Base
  belongs_to :order
  belongs_to :user

  after_create :alert_order

  private
  
  def alert_order
    order.new_note(self)
  end
end

