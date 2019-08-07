class CreateRatingLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :rating_links  do |t|
      t.string :uuid
      t.string :user_id
      t.column :expires_at,  :datetime
      t.timestamps
    end
  end
end
