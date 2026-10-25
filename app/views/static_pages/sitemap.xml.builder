base_url = "#{Setting.url.protocol}://#{request.host_with_port}"
xml.instruct! :xml, :version=>'1.0'

# lastmod 要是實際的修改時間；一律填今天會讓 Google 忽略整份 sitemap 的 lastmod
xml.tag! 'urlset', "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  xml.url do
    xml.loc "#{base_url}"
    xml.changefreq "daily"
    xml.priority 1.0
  end

  @system_articles.each do |system_type, article|
    xml.url do
      xml.loc "#{base_url}/#{system_type}"
      xml.lastmod article.updated_at.to_date
      xml.changefreq "monthly"
      xml.priority 1.0
    end
  end

  xml.url do
    xml.loc "#{base_url}/articles"
    xml.lastmod @articles.maximum(:updated_at)&.to_date
    xml.changefreq "daily"
    xml.priority 1.0
  end

  %w(presses activities comments epapers books).each do |kind|
    xml.url do
      xml.loc "#{base_url}/articles/#{kind}"
      xml.changefreq "daily"
      xml.priority 0.9
    end
  end

  @keywords.each do |keyword|
    xml.url do
      xml.loc keyword_url(keyword) # keywords 資料表沒有 updated_at，不填 lastmod
      xml.changefreq "monthly"
      xml.priority 0.9
    end
  end

  @articles.each do |article|
    xml.url do
      xml.loc article_url(article)
      xml.lastmod article.updated_at.to_date
      xml.changefreq "monthly"
      xml.priority 0.9
    end
  end
end
