require 'unicode/display_width'

module ApplicationHelper
  SITE_DESCRIPTION = '財團法人民間司法改革基金會致力於監督司法、推動司法改革，促進台灣司法的公正、透明與民主，保障人民的訴訟權益。'.freeze

  def default_meta_tags
    if Setting.url.protocol == 'http'
      canonical_url = request.url
    else
      canonical_url = request.url.sub(/^http:\/\//, "#{Setting.url.protocol}://")
    end
    {
      separator: "&mdash;".html_safe,
      site: '財團法人民間司法改革基金會',
      reverse: true,
      description: SITE_DESCRIPTION,
      canonical: canonical_url,
      author: Setting.google.pages,
      publisher: Setting.google.pages,
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
    image_url = article.image.blank? ? "#{site_base_url}/images/jrf-img.png" : "#{site_base_url}#{article.image}"
    data = {
      "@context" => "https://schema.org",
      "@type" => "NewsArticle",
      "mainEntityOfPage" => { "@type" => "WebPage", "@id" => article_url(article) },
      "headline" => article.title.to_s.truncate(110),
      "image" => [image_url],
      "datePublished" => article.published_at.to_time.iso8601,
      "dateModified" => article.updated_at.iso8601,
      "description" => strip_tags(article.description.to_s),
      "author" => { "@type" => "Organization", "name" => "財團法人民間司法改革基金會" },
      "publisher" => {
        "@type" => "Organization",
        "name" => "財團法人民間司法改革基金會",
        "logo" => { "@type" => "ImageObject", "url" => "#{site_base_url}/images/logo.png" }
      }
    }
    data["author"] = { "@type" => "Person", "name" => article.author } if article.author.present?
    json_ld_tag(data)
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
