class Keyword < ApplicationRecord
  belongs_to :category
  has_many :faqs, dependent: :destroy
  has_many :slides, as: :slideable, dependent: :destroy
  accepts_nested_attributes_for :faqs, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :slides, reject_if: proc { |attributes| attributes['image'].blank? }, allow_destroy: true
  has_and_belongs_to_many :articles, index: { unique: true }
  validates_presence_of :name, message: '請填專案字名稱'
  # validates_presence_of :title, message: '請填專案標題'
  # validates_presence_of :content, message: '請填專案內文'
  validates_uniqueness_of :name, message: '請確認名稱沒有重複'
  validates :cover, presence: { message: '當專案在首頁顯示時必須上傳封面圖片' }, if: :showed?
  mount_uploader :image, ImageUploader
  mount_uploader :cover, ImageUploader
  scope :published, -> { where(published: true) }
  # 用 reorder 取代預設排序；unscoped 會把前面串的 includes 等條件一起丟掉
  scope :showed, -> { where(showed: true).reorder(show_position: :asc) }
  default_scope { order(position: :asc) }
  delegate :catalog, to: :category

  before_save :set_position, :fix_content

  def set_position
    self.position ||= Keyword.maximum("position").to_i + 1
  end

  def self.build #-> allows you to call a single method
    keyword = self.new
    keyword.faqs.build
    return
  end

  def fix_content
    self.content = self.content.gsub("href=\"#{Setting.url.protocol}://#{Setting.url.host}", "href=\"/") if self.content.present?
  end

  # Ransack 只允許搜尋這些欄位（專案：前台以關鍵字名稱搜尋文章、API 搜尋名稱、後台依目錄篩選）
  def self.ransackable_attributes(auth_object = nil)
    %w[name title content category_id]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
