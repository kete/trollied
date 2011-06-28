members = Order.workflow_event_names.inject(Hash.new) do |hash, event_name|
  hash[event_name.to_sym] = :post
  hash
end

ActionController::Routing::Routes.draw do |map|
  map.resources :orders, :member => members, :except => [:new, :create], :has_many => :line_items, :has_many => :notes
end
