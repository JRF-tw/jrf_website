class Site < ApplicationRecord
  mount_uploader :image, ImageUploader
  default_scope { order(position: :asc) }
  before_save :set_position

  def set_position
    self.position ||= Site.maximum("position").to_i + 1
  end

  # Ransack 只允許搜尋這些欄位（相關網站）
  def self.ransackable_attributes(auth_object = nil)
    %w[title]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
