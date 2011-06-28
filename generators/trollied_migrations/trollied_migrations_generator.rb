class TrolliedMigrationsGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'trolleys_migration.rb', 'db/migrate', { :migration_file_name => "create_trolleys" }
      m.sleep(1)
      m.migration_template 'orders_migration.rb', 'db/migrate', { :migration_file_name => "create_orders" }
      m.sleep(1)
      m.migration_template 'line_items_migration.rb', 'db/migrate', { :migration_file_name => "create_line_items" }
      m.sleep(1)
      m.migration_template 'notes_migration.rb', 'db/migrate', { :migration_file_name => "create_notes" }
    end
  end
end
