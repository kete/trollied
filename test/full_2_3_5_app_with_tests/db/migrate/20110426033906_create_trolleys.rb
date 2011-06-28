class CreateTrolleys < ActiveRecord::Migration
  def self.up
    create_table :trolleys do |t|
      t.integer :user_id, :null => false

      t.timestamps
    end

  end

  def self.down
    drop_table :trolleys
  end
end
