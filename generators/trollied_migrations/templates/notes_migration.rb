class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :order_id, :user_id, :null => false
      t.string :body, :null => false

      t.timestamps
    end

  end

  def self.down
    drop_table :notes
  end
end
