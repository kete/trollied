module GetsTrolliedControllerHelpers
  def self.included(klass)
    klass.send :helper_method, :url_for_purchasable_item, :target_action, :target_controller
  end

  def target_controller(options = {})
    purchasable_item_params_name = options.delete(:purchasable_item_params_name) || @purchasable_item_params_name
    options.delete(:controller) || purchasable_item_params_name.pluralize || params[:controller]
  end

  def target_action(options = {})
    options.delete(:action) || 'show'
  end

  def target_id(options = {})
    purchasable_item = options.delete(:purchasable_item) || @purchasable_item
    options.delete(:id) || purchasable_item
  end

  def url_for_purchasable_item(options = { })
    defaults = {
      :controller => target_controller(options),
      :action => target_action(options),
      :id => target_id(options)
    }

    url_for(defaults.merge(options))
  end
end
