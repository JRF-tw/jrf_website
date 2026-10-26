atom_feed ({language: 'zh-TW'}) do |feed|
  feed.title "民間司法改革基金會"
  feed.updated @articles.map(&:updated_at).max

  @articles.each do |article|
    feed.entry article, {published: article.published_at, updated: article.updated_at} do |entry|
      entry.title article.title
      entry.content article.content, type: 'html'
      entry.author do |author|
        author.name article.author
      end
      entry.summary article.description, type: 'html'
    end
  end
end