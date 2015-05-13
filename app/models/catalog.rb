class Catalog < ActiveRecord::Base
  has_many :categories
  has_many :keywords, through: :categories
  validates_presence_of :name, message: '請填寫分類名稱'
  validates_presence_of :image, message: '請上傳圖片'
  mount_uploader :image, ImageUploader
  scope :published, -> { where(published: true) }
  default_scope { order(position: :asc) }
  before_save :set_position

  def set_position
    if not self.position
      self.position = Catalog.maximum("position").to_i + 1
    end
  end
end
