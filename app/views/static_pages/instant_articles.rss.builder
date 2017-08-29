#encoding: UTF-8

xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "民間司法改革基金會"
    xml.author "民間司法改革基金會"
    xml.description "結合民間力量，持續推動改革，以建立公平、正義、值得人民信賴的司法。"
    xml.link root_url
    xml.language "zh-Hant"

    for article in @articles
      xml.item do
        if article.title
          xml.title article.title
        else
          xml.title ""
        end
        xml.author article.author
        xml.pubDate article.published_at.to_s(:iso8601)
        xml.link article_url(article)
        xml.guid article_url(article)
        xml.tag!("content:encode") do
          xml.cdata!(render partial: 'article', locals: {article: article})
        end
        xml.description sanitize(article.description)
      end
    end
  end
end