class Category < ApplicationRecord
  has_many :keywords
  has_many :published_keywords, -> { where(published: true) }, class_name: 'Keyword', foreign_key: 'category_id'
  belongs_to :catalog
  validates_presence_of :name, message: '請填寫分類名稱'
  validates_presence_of :catalog_id, message: '請選擇主分類'
  scope :published, -> { where(published: true) }
  default_scope { order(position: :asc) }
  before_save :set_position
  validates_uniqueness_of :name, message: '請確認名稱沒有重複'
  before_destroy :check_keywords_empty, prepend: true

  def full_name
    "#{self.catalog.name} > #{self.name}"
  end

  def set_position
    self.position ||= Category.maximum("position").to_i + 1
  end

  def chunk_keywords
    unless self.published_keywords.blank?
      max_length = ( self.published_keywords.length + self.width - 1 ) / self.width
      self.published_keywords.each_slice(max_length).to_a
    else
      []
    end
  end

  def check_keywords_empty
    if self.keywords.length > 0
      names = []
      self.keywords.each do |k|
        names << k.name
      end
      names = names.join('、')
      message = "專案並未刪除完畢： #{names}"
      errors.add(:base, message)
      throw(:abort)
    end
  end
end
