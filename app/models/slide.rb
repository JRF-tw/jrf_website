class Slide < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :slideable, polymorphic: true
  default_scope { order(position: :asc) }
  before_save :set_position

  def set_position
    self.position ||= Keyword.maximum("position").to_i + 1
  end
end
