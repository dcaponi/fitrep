class RenameRatingLinkToSurvey < ActiveRecord::Migration[5.2]
  def change
    rename_table :rating_links, :surveys
    rename_column :ratings, :rating_link_uuid, :survey_uuid
  end
end
