class Article < ApplicationRecord
  belongs_to :user, optional: true
  has_and_belongs_to_many :keywords, index: { unique: true }
  has_many :slides, as: :slideable, dependent: :destroy
  accepts_nested_attributes_for :slides, reject_if: proc { |attributes| attributes['image'].blank? }, allow_destroy: true
  # 同一天的文章再依 id 排，順序才固定（分頁不會重複或漏掉）
  default_scope { order(published_at: :desc, id: :desc) }
  scope :published, -> { where(published: true) }
  # kind != 'system' 在 SQL 會連 kind 是 NULL 的也排除，所以要另外加回來
  scope :not_system, -> { where(kind: nil).or(where.not(kind: 'system')) }
  mount_uploader :image, ImageUploader
  paginates_per 15

  KIND_NAMES = { 'press' => '新聞稿', 'activity' => '活動', 'comment' => '評論', 'epaper' => '電子報', 'book' => '書籍' }.freeze
  scope :activities, -> { where(kind: 'activity') }
  scope :presses, -> { where(kind: 'press') }
  # scope :videos, -> { where(kind: 'video') }
  scope :comments, -> { where(kind: 'comment') }
  scope :epapers, -> { where(kind: 'epaper') }
  scope :books, -> { where(kind: 'book') }
  before_save :update_youtube_values, :fix_content
  validate :check_content
  validates_presence_of :published_at

  # Article search is exposed to anonymous visitors with a raw `params[:q]`.
  # Restrict which fields/associations Ransack will query so it can't be used
  # to probe sensitive data through the :user association (e.g. admin emails).
  def self.ransackable_attributes(auth_object = nil)
    %w[title content author published_at kind]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[keywords]
  end

  def youtube_embed_url
    if youtube_id.present?
      if youtube_list_id.present?
        "//www.youtube.com/embed/#{youtube_id}?list=#{youtube_list_id}&rel=0&wmode=opaque"
      else
        "//www.youtube.com/embed/#{youtube_id}?rel=0&wmode=opaque"
      end
    else
      nil
    end
  end

  def update_youtube_values
    if self.youtube_url.blank?
      self.youtube_id = nil
      self.youtube_list_id = nil
      return true
    end
    youtube_id, youtube_list_id = extract_youtube_id(self.youtube_url)
    unless youtube_id
      self.youtube_url = nil
      self.youtube_id = nil
      self.youtube_list_id = nil
      errors.add(:base, 'youtube網址錯誤')
      throw(:abort)
    end
    if self.youtube_id == youtube_id && self.youtube_list_id == youtube_list_id
      # means that youtube is the same, no need to update.
      return nil
    end
    self.youtube_id = youtube_id
    self.youtube_list_id = youtube_list_id
    if youtube_list_id.blank?
      self.youtube_url = "https://www.youtube.com/watch?v=" + youtube_id
    else
      self.youtube_url = "https://www.youtube.com/watch?v=" + youtube_id + "&list=" + youtube_list_id
    end
  end

  private

  def extract_youtube_id(url)
    youtube_uri = URI.parse(url)
    if youtube_uri.host == 'www.youtube.com'
      params = youtube_uri.query
      if params
        youtube_id = CGI::parse(params)['v'].first
        youtube_list_id = CGI::parse(params)['list'].first
        return youtube_id, youtube_list_id
      else
        youtube_id = youtube_uri.path.split('/')[-1]
        youtube_list_id = nil
        return youtube_id, youtube_list_id
      end
    elsif youtube_uri.host == 'youtu.be'
      youtube_id = youtube_uri.path[1..-1]
      youtube_list_id = CGI::parse(params)['list'].first
      return youtube_id, youtube_list_id
    else
      self.youtube_url = nil
      errors.add(:base, 'youtube網址錯誤')
      return false, nil
    end
  end

  def fix_content
    self.content = self.content.gsub("href=\"#{Setting.url.protocol}://#{Setting.url.host}", "href=\"/")
  end

  def check_content
    unless self.kind == 'system'
      errors.add(:content, '內容不能為空') if self.content.strip.blank?
    end
  end
end
