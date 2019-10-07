class Survey < ApplicationRecord
  validates :user_id,  :presence => true
  has_many :questions
end
