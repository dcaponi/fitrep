class Rating < ApplicationRecord
  belongs_to :survey
  validates :user_id,     :presence => true
  validates :rater_ip,    :presence => true
  validates :survey_uuid, :presence => true
  validates :rating,
    :presence     => true,
    :numericality => true,
    :inclusion    => {:in => 1..10, :message => "Value should range 1 - 10"}
end
