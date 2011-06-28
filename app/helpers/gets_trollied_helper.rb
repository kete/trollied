# include this to gain helpers for shopping trolley
module GetsTrolliedHelper
  include HasTrolleyControllerHelpers::UrlFor

  # wrapped in a div to allow for styling the form to be inline
  def button_to_place_in_trolley(purchasable_item)
    "<div class=\"add-to-trolley\">" +
      button_to(t('gets_trollied_helper.add_to_trolley'),
                :controller => :line_items,
                :action => :create,
                purchasable_item.class.as_foreign_key_sym => purchasable_item) +
      "</div>"
  end

  # TODO: trolley link

  def in_trolley_status_or_button_to_place_in_trolley(purchasable_item)
    html = String.new
    if current_user && current_user != false &&
        current_user.respond_to?(:trolley) &&
        current_user.trolley.has_active_order_for?(purchasable_item)
      html = "<div class=\"in-trolley\">" +
        t('gets_trollied_helper.in_trolley') +
        "</div>"
    else
      html = button_to_place_in_trolley(purchasable_item)
    end
    html
  end

end
