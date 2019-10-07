class TieRatingToSurvey < ActiveRecord::Migration[5.2]
  def change
    remove_column :ratings, :survey_id
    add_column :ratings, :question_id, :string
  end
end
