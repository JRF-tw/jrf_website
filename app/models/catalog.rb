class Catalog < ApplicationRecord
  has_many :categories
  has_many :keywords, through: :categories
  validates_presence_of :name, message: '請填寫分類名稱'
  validates_presence_of :image, message: '請上傳圖片'
  mount_uploader :image, ImageUploader
  scope :published, -> { where(published: true) }
  default_scope { order(position: :asc) }
  before_save :set_position
  validates_uniqueness_of :name, message: '請確認名稱沒有重複'
  before_destroy :check_categories_empty, prepend: true

  def set_position
    self.position ||= Catalog.maximum("position").to_i + 1
  end

  def width_unit
    12 / self.categories.published.sum(:width)
  end

  def check_categories_empty
    if self.categories.length > 0
      names = []
      self.categories.each do |c|
        names << c.name
      end
      names = names.join('、')
      message = "子分類並未刪除完畢： #{names}"
      errors.add(:base, message)
      throw(:abort)
    end
  end
end
