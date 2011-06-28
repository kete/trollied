ActionController::Routing::Routes.draw do |map|
  map.resources :user do |user|
    user.resource :trolley, :only => :show do |trolley|
      trolley.resources :purchase_orders, :shallow => true
    end
  end

  map.resources :items, :has_many => :line_items
end
