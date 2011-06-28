class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :trolley_id, :null => false
      t.string :workflow_state, :default => 'current', :null => false

      t.timestamps
    end

  end

  def self.down
    drop_table :orders
  end
end
