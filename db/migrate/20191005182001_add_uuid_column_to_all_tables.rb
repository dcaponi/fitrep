class AddUuidColumnToAllTables < ActiveRecord::Migration[5.2]
  def change
    tables = [ "ratings", "surveys", "projects" ]

    tables.each do |table|
      add_column table, :uuid, :uuid, default: "uuid_generate_v4()", null: false
      remove_column table, :id
      rename_column table, :uuid, :id
      execute "ALTER TABLE #{table} ADD PRIMARY KEY (id);"
    end
    
    remove_column :ratings, :user_id
  end
end
