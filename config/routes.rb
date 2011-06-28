members = Hash.new
event_objects = Order.workflow_spec.states.values.collect &:events
events = event_objects.collect { |h| h.keys}.flatten.compact
events.each do |name|
  members[name.to_sym] = :post
end

ActionController::Routing::Routes.draw do |map|
  map.resources :orders, :member => members, :except => [:new, :create], :has_many => :line_items
end
