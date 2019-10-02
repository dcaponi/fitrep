class Rating < ApplicationRecord
  belongs_to :rating_link
  validates :user_id,          :presence => true
  validates :rater_ip,         :presence => true
  validates :rating_link_uuid, :presence => true
  validates :rating,
    :presence     => true,
    :numericality => true,
    :inclusion    => {:in => 1..10, :message => "Value should range 1 - 10"}
end
