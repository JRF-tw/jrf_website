class Site < ApplicationRecord
  mount_uploader :image, ImageUploader
  default_scope { order(position: :asc) }
  before_save :set_position

  def set_position
    self.position ||= Site.maximum("position").to_i + 1
  end
end
