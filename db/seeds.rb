# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
include ActionView::Helpers

Catalog.delete_all
Category.delete_all
Article.delete_all
Magazine.delete_all
Column.delete_all
MagazineArticle.delete_all
Epaper.delete_all

ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

catalogs = [
  {
    name: '建立信賴的司法',
    categories: [
      {
        name: '司法改革藍圖',
        keywords: [
          {
            name: '司法憲政改革'
          }, {
            name: '全國司法改革會議'
          }, {
            name: '第一代司法改革藍圖'
          }, {
            name: '第二代司法改革藍圖'
          }
        ]
      }, {
        name: '司法民主化',
        keywords: [
          {
            name: '人民參與審判'
          }
        ]
      }
    ]
  }, {
    name: '監督法官檢察官',
    categories: [
      {
        name: '檢舉不適任法官檢察官',
        keywords: [
          {
            name: '申訴中心'
          }
        ]
      }, {
        name: '法官制度改革',
        keywords: [
          {
            name: '法官制度改革介紹'
          }, {
            name: '法官制度改革法案'
          }, {
            name: '法官個案評鑑'
          }, {
            name: '法官檢察官監督網'
          }
        ]
      }
    ]
  }, {
    name: '冤案救援',
    categories: [
      {
        name: '救援個案',
        keywords: [
          {
            name: '冤案申訴'
          }, {
            name: '徐自強案'
          }, {
            name: '邱和順案'
          }, {
            name: '江國慶案'
          }, {
            name: '蘇建和案'
          }, {
            name: '蔡學良案'
          }, {
            name: '梅福安案'
          }
        ]
      }, {
        name: '釋憲小組',
        keywords: []
      }
    ]
  }, {
    name: '實現社會正義',
    categories: [
      {
        name: '控訴國家暴力',
        keywords: [
          {
            name: '反黑箱服貿案'
          }, {
            name: '反核四案'
          }, {
            name: '烏來案'
          }, {
            name: '華光社區案'
          }, {
            name: '陳雲林案'
          }
        ]
      }, {
        name: '人頭帳戶案',
        keywords: []
      }
    ]
  }
]

catalogs.each do |c|
  catalog = Catalog.new
  catalog.name = c[:name]
  catalog.save
  c[:categories].each do |cc|
    category = Category.new
    category.name = cc[:name]
    category.catalog_id = catalog.id
    category.save
    cc[:keywords].each do |k|
      keyword = Keyword.new
      keyword.name = k[:name]
      keyword.category_id = category.id
      keyword.save
    end
  end
end

rte_path = Rails.root.join('db', 'data', 'rte.json')

if File.file?(rte_path)
  File.readlines(rte_path).each do |line|
    article_data = JSON.parse(line)
    article = Article.new
    article.id = article_data[0]
    article.title = article_data[1]
    article.content = article_data[2]
    if article_data[3].empty?
      article.published_at = Date.today
    else
      article.published_at = Date.parse(article_data[3])
      article.created_at = Date.parse(article_data[3])
    end
    article.author = article_data[5]
    article.image = article_data[7]
    article.description = article_data[8]
    article.published = true
    article.save
  end
end



magazine_path = Rails.root.join('db', 'data', 'magazines.json')
#["標題","作者","卷","期","日期","專欄","全文","註釋"]
if File.file?(magazine_path)
  File.readlines(magazine_path).each do |line|
    magazine_article_data = JSON.parse(line)
    magazine_article = MagazineArticle.new
    magazine = Magazine.where(issue: magazine_article_data[3]).first
    unless magazine
      magazine = Magazine.new
      magazine.volumn = magazine_article_data[2]
      magazine.issue = magazine_article_data[3]
      magazine.id = magazine_article_data[3]
      published_at = Date.parse(magazine_article_data[4])
      magazine.published_at = published_at
      magazine.name = "司改雜誌第#{magazine_article_data[3]}期"
      magazine.created_at = published_at
      magazine.save
    end
    magazine_article.magazine = magazine
    column = Column.where(name: magazine_article_data[5]).first
    unless column
      column = Column.new
      column.name = magazine_article_data[5]
      column.save
    end
    magazine_article.column = column
    magazine_article.title = magazine_article_data[0].gsub(/\n/, '')
    magazine_article.author = magazine_article_data[1]
    magazine_article.content = simple_format(magazine_article_data[6]).gsub(/\n/, '')
    magazine_article.comment = simple_format(magazine_article_data[7]).gsub(/\n/, '')
    magazine_article.save
  end
end



epaper_path = Rails.root.join('db', 'data', 'epapers.json')

if File.file?(epaper_path)
  File.readlines(epaper_path).each do |line|
    epaper_data = JSON.parse(line)
    epaper = Epaper.new
    epaper.id = epaper_data[0]
    epaper.title = epaper_data[3]
    epaper.filename = epaper_data[2]
    e_path = Rails.root.join('db', 'epapers', epaper_data[2])
    if File.file?(e_path)
      content = File.read(e_path)
      encoding = CharlockHolmes::EncodingDetector.detect(content)[:encoding]
      unless encoding == "UTF-8"
        #ic = Iconv.new('UTF-8//IGNORE', encoding)
        #content = ic.iconv(content)
        # Another way
        content = CharlockHolmes::Converter.convert(content, encoding, 'UTF-8')
      end
      epaper.content = content
    else
      epaper.content = ''
    end
    epaper.published_at = Date.parse(epaper_data[1])
    epaper.created_at = epaper.published_at
    epaper.save
  end
end

ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end