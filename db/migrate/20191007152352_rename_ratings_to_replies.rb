class RenameRatingsToReplies < ActiveRecord::Migration[5.2]
  def change
    rename_table :ratings, :replies
  end
end
