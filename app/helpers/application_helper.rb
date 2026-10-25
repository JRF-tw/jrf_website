require 'unicode/display_width'

module ApplicationHelper
  SITE_DESCRIPTION = '財團法人民間司法改革基金會致力於監督司法、推動司法改革，促進台灣司法的公正、透明與民主，保障人民的訴訟權益。'.freeze

  def default_meta_tags
    {
      separator: "&mdash;".html_safe,
      site: '財團法人民間司法改革基金會',
      reverse: true,
      description: SITE_DESCRIPTION,
      canonical: canonical_url,
      # 允許 Google 搜尋與 Discover 顯示大圖預覽
      robots: { "max-image-preview" => "large" },
      og: {
        title: '財團法人民間司法改革基金會',
        description: SITE_DESCRIPTION,
        type: 'website',
        image: "#{Setting.url.protocol}://#{Setting.url.host}/images/jrf.jpg",
        site_name: '財團法人民間司法改革基金會',
        url: canonical_url
      },
      twitter: {
        card: 'summary_large_image',
        image: "#{Setting.url.protocol}://#{Setting.url.host}/images/jrf.jpg"
      },
      fb: {
        pages: Setting.fb.pages
      }
    }
  end

  def site_base_url
    "#{Setting.url.protocol}://#{Setting.url.host}"
  end

  # 只保留路徑與頁碼：追蹤參數（utm_*、fbclid）、專案頁的分類篩選、搜尋條件都指回同一頁
  def canonical_url
    url = "#{request.base_url.sub(/\Ahttps?:/, "#{Setting.url.protocol}:")}#{request.path}"
    page = params[:page].to_i
    page > 1 ? "#{url}?page=#{page}" : url
  end

  # JSON-LD structured data for the organization (used on the home page).
  def organization_structured_data
    data = {
      "@context" => "https://schema.org",
      "@type" => "NGO",
      "name" => "財團法人民間司法改革基金會",
      "alternateName" => "民間司改會",
      "url" => site_base_url,
      "logo" => "#{site_base_url}/images/logo.png",
      "description" => SITE_DESCRIPTION
    }
    same_as = [Setting.url.fb, Setting.google.pages].reject(&:blank?)
    data["sameAs"] = same_as if same_as.any?
    json_ld_tag(data)
  end

  # JSON-LD NewsArticle structured data for an article page.
  def article_structured_data(article)
    # banner 是 1600x900（16:9），符合 Google Discover 建議的 1200px 寬以上
    images = article.image.blank? ? ["#{site_base_url}/images/jrf-img.png"] : ["#{site_base_url}#{article.image.banner.url}", "#{site_base_url}#{article.image.url}"]
    data = {
      "@context" => "https://schema.org",
      "@type" => "NewsArticle",
      "mainEntityOfPage" => { "@type" => "WebPage", "@id" => article_url(article) },
      "headline" => article.title.to_s.truncate(110),
      "image" => images,
      "datePublished" => article.published_at.in_time_zone.iso8601,
      "dateModified" => article.updated_at.iso8601,
      "description" => strip_tags(article.description.to_s).strip,
      "author" => article_author_structured_data(article.author),
      "publisher" => {
        "@type" => "Organization",
        "name" => "財團法人民間司法改革基金會",
        "url" => site_base_url,
        "logo" => { "@type" => "ImageObject", "url" => "#{site_base_url}/images/logo.png" }
      }
    }
    json_ld_tag(data)
  end

  ORGANIZATION_AUTHOR = /基金會|聯盟|聲明|聯合|辦公室|團體|協會|信託|志工|司改會|Foundation/i

  # 作者欄位是自由填寫：組織名稱標成 Organization、單純的人名標成 Person；
  # 多人分工或帶職稱（例如「文字｜Eiley；設計｜Mido」）無法可靠拆解，改用基金會本身
  def article_author_structured_data(author)
    name = author.to_s.strip
    if name.blank? || name.match?(%r{[／/｜|；;、,，]})
      { "@type" => "Organization", "name" => "財團法人民間司法改革基金會", "url" => site_base_url }
    elsif name.match?(ORGANIZATION_AUTHOR)
      { "@type" => "Organization", "name" => name }
    else
      { "@type" => "Person", "name" => name }
    end
  end

  def json_ld_tag(data)
    json = ERB::Util.json_escape(JSON.generate(data))
    content_tag(:script, json.html_safe, type: "application/ld+json")
  end

  def display_shorter(str, length, additional = "...")
    length = length * 2
    text = Nokogiri::HTML(str).text
    if Unicode::DisplayWidth.of(text) >= length
      additional_text = Nokogiri::HTML(additional).text
      new_length = length - Unicode::DisplayWidth.of(additional_text)
      short_string = text[0..new_length]
      while Unicode::DisplayWidth.of(short_string) > new_length
        short_string = short_string[0..-2]
      end
      short_string + additional
    else
      text
    end
  end

  def instant_article_content(content)
    html = Nokogiri::HTML(content)
    elements = html.css('h1,h2,h3,h4,h5,h6,p,img,p+ul,p+ol')
    result = ''
    elements.each do |e|
      if ['h1','h2','h3','h4','h5','h6','p'].include? e.node_name
        result += "<#{e.node_name}>#{e.text}</#{e.node_name}>"
      elsif ['ul', 'ol'].include? e.node_name
        result += e.to_html
      elsif e.node_name == 'img'
        result += "<figure><img src=\"#{Setting.url.protocol}://#{Setting.url.host}#{e.attr('src')}\" /></figure>"
      end
    end
    return result
  end
end
