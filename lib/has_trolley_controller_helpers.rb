module HasTrolleyControllerHelpers
  def self.included(klass)
    klass.send :helper_method, :url_for_trolley, :url_for_order
    klass.send :include, UrlFor
  end
  
  module UrlFor
    # expects user in options or @user or trolley being set
    def url_for_trolley(options = { })
      user = options[:user]
      trolley = options[:trolley] || @trolley || user.trolley

      if trolley.blank?
        user = @user
      else
        user = trolley.user
      end

      # TODO: Hack, not sure if this is 2.3.5 bug or my ignorance
      # but url_for returns marshalled trolley, in addition to correct url
      url = url_for(:user_id => user.id,
                    :controller => :trolleys,
                    :action => :show).split(".%23%")[0]
    end

    # expects order
    # either as instance variables or in options
    def url_for_order(options = { })
      trolley = options[:trolley] || @trolley
      trolley = @order.trolley if @order && trolley.blank?

      order = options[:order] || @order || trolley.selected_order
      trolley = order.trolley

      url_for [trolley.user, trolley, order]
    end

    def url_for_order_or_trolley
      raise unless @order

      if @order.user == current_user
        url_for_trolley :trolley => @order.trolley
      else
        url_for_order
      end
    end
  end
end
