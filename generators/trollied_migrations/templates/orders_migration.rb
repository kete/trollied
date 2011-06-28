class CreatePurchaseOrders < ActiveRecord::Migration
  def self.up
    create_table :purchase_orders do |t|
      t.integer :trolley_id, :null => false

      t.timestamps
    end

  end

  def self.down
    drop_table :purchase_orders
  end
end
