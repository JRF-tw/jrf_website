class Category < ApplicationRecord
  has_many :keywords
  belongs_to :catalog
  validates_presence_of :name, message: '請填寫分類名稱'
  validates_presence_of :catalog_id, message: '請選擇主分類'
  scope :published, -> { where(published: true) }
  default_scope { order(position: :asc) }
  before_save :set_position
  validates_uniqueness_of :name, message: '請確認名稱沒有重複'
  before_destroy :check_keywords_empty

  def full_name
    "#{self.catalog.name} > #{self.name}"
  end

  def set_position
    self.position ||= Category.maximum("position").to_i + 1
  end

  def chunk_keywords
    unless self.keywords.published.blank?
      max_length = ( self.keywords.published.length + self.width - 1 ) / self.width
      self.keywords.published.each_slice(max_length).to_a
    else
      []
    end
  end

  def check_keywords_empty
    return self.keywords.length == 0
  end
end
