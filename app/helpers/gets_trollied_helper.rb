# include this to gain helpers for shopping trolley
module GetsTrolliedHelper
  def link_to_place_in_trolley(purchasable_item)
    button_to(t('gets_trollied_helper.add_to_cart'),
              :controller => :line_items,
              :action => :create,
              purchasable_item.class.as_foreign_key_sym => purchasable_item)
  end
end
