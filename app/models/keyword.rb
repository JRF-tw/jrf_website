class Keyword < ActiveRecord::Base
  has_and_belongs_to_many :articles, -> { uniq }
  has_and_belongs_to_many :magazine_articles, -> { uniq }
  validates_presence_of :name, message: '請填寫關鍵字名稱'
end