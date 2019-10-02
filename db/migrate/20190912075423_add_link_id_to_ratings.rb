class AddLinkIdToRatings < ActiveRecord::Migration[5.2]
  def change
    add_column :ratings, :rating_link_uuid, :string
    Rating.find_each do |rating|
      rating.rating_link_uuid = user_active_rating_link_uuid(rating.user_id)
      rating.save
    end
  end

  def user_active_rating_link_uuid(user_id)
    RatingLink.where(user_id: user_id).order(:created_at).last.uuid
  end
end
