module HasTrolleyControllerHelpers
  unless included_modules.include? HasTrolleyControllerHelpers
    def self.included(klass)
      klass.send :helper_method, :url_for_trolley
    end

    # expects user in options or @user or trolley being set
    def url_for_trolley(options = { })
      user = options[:user] || @user
      user = @trolley.user if @trolley && user.blank?

      trolley = options[:trolley] || @trolley || user.trolley

      # TODO: Hack, not sure if this is 2.3.5 bug or my ignorance
      # but url_for returns marshalled trolley, in addition to correct url
      url = url_for([user, trolley]).split(".%23%")[0]
    end

    # expects purchase_order
    # either as instance variables or in options
    def url_for_purchase_order(options = { })
      trolley = options[:trolley] || @trolley
      trolley = @purchase_order.trolley if @purchase_order && trolley.blank?

      purchase_order = options[:purchase_order] || @purchase_order || trolley.purchase_order
      
      url_for [trolley.user, trolley, purchase_order]
    end

  end
end
