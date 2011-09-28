require 'workflow'

ActionController::Base.send(:include, GetsTrolliedControllerHelpers)
ActionController::Base.send(:include, HasTrolleyControllerHelpers)
ActionController::Base.send(:helper, GetsTrolliedHelper)
ActionController::Base.send(:helper, OrdersHelper)
ActionController::Base.send(:helper, LineItemsHelper)

# load our locales
# I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', 'config', 'locales', '*.{rb,yml}') ]
