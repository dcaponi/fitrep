class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.string :user_id
      t.integer :rating
      t.text :comment
      t.string :rater_ip
      t.string :project_id

      t.timestamps
    end
  end
end
