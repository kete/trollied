class Item < ActiveRecord::Base
  include GetsTrollied
  set_up_to_get_trollied :described_as => :label
end
