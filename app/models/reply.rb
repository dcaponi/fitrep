class Reply < ApplicationRecord
  belongs_to :question

  validates :rater_ip, :presence => true
  validates :rating,
    :presence     => true,
    :numericality => true,
    :inclusion    => {:in => 1..10, :message => "Value should range 1 - 10"}
end
