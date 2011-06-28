module LineItemsHelper
  def link_to_purchasable_in(line_item)
    link_to line_item.description_for_purchasing, line_item.purchasable_item
  end
end
