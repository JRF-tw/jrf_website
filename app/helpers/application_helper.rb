require 'unicode/display_width'

module ApplicationHelper
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
      description: '',
      canonical: canonical_url,
      author: Setting.google.pages,
      publisher: Setting.google.pages,
      og: {
        title: '財團法人民間司法改革基金會',
        description: '',
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
