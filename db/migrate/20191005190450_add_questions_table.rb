class AddQuestionsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :questions, id: :uuid do |t|
      t.string :text
      t.boolean :allows_comment
      t.string :survey_id
    end
  end
end
