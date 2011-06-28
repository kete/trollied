# simple model for adding notes by either staff or ordering user to an order
# note is body attribute
class Note < ActiveRecord::Base
  belongs_to :order
  belongs_to :user
end

