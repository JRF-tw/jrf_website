class Video < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :keywords, -> { uniq }
  default_scope { order(created_at: :desc) }
  scope :published, -> { where(published: true) }
  mount_uploader :image, ImageUploader
end
