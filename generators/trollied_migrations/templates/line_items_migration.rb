class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.integer :purchase_order_id, :null => false
      t.integer :purchasable_item_id, :null => false #, :references => nil this may blow up
      t.string  :purchasable_item_type, :null => false

      t.timestamps
    end

  end

  def self.down
    drop_table :line_items
  end
end
