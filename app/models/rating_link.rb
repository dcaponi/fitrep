class RatingLink < ApplicationRecord
  before_create :set_uuid

  def set_uuid
    self.uuid = SecureRandom.hex(32)
  end
end
