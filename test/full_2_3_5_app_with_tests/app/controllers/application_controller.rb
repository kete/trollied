# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # for now, for testing purposes, just returns a user
  def current_user
    User.first || User.create!(:name => "Franz Ficklestein")
  end

  helper_method :current_user
end
