class StaticPagesController < ApplicationController
  # 搜尋頁分類分頁的 k 參數對應到 Article#kind
  SEARCH_KINDS = { 'presses' => 'press', 'activities' => 'activity', 'comments' => 'comment', 'epapers' => 'epaper', 'books' => 'book' }.freeze

  def home
    @showed_keywords = Keyword.showed
    @keywords = Keyword.showed.includes(:category).first(5)
    @first_keyword = @keywords.shift
    @articles = Article.includes(:keywords).published.page(params[:page]).per(6)
    @sites = Site.all
    @epaper_article = Article.epapers.first
    @book_articles = Article.books.first(6)
  end

  def search
    @query = params[:q]
    @kind = params[:k] if SEARCH_KINDS.key?(params[:k])
    articles = Article.published.where.not(kind: 'system').ransack(title_or_content_cont: @query).result
    articles = articles.where(kind: SEARCH_KINDS[@kind]) if @kind
    @articles = articles.page(params[:page])
    # @videos = Video.published.ransack(title_or_content_cont: q).result.page(params[:videos_page])
    # @kinds = []
    # @articles.each do |a|
    #   unless @kinds.include? a.kind
    #     @kinds << a.kind if a.kind
    #   end
    # end
    # puts @kinds
    set_meta_tags({
      title: "搜尋文章",
      og: {
        title: "搜尋文章"
      }
    })
  end

  def about
    @article = Article.where(kind: 'system', system_type: 'about').first
    set_meta_tags({
      title: "關於我們",
      og: {
        title: "關於我們",
        image: @article.image.blank? ? "#{Setting.url.protocol}://#{Setting.url.host}/images/jrf-img.png" : "#{Setting.url.protocol}://#{Setting.url.host}#{@article.image}"
      },
      article: {
        author: 'https://www.facebook.com/jrf.tw',
        published_time: @article.published_at.strftime('%FT%T%:z'),
        modified_time: @article.updated_at.strftime('%FT%T%:z')
      },
      twitter: {
        image: @article.image.blank? ? "#{Setting.url.protocol}://#{Setting.url.host}/images/jrf-img.png" : "#{Setting.url.protocol}://#{Setting.url.host}#{@article.image}",
      }
    })
  end

  def donate
    @article = Article.where(kind: 'system', system_type: 'donate').first
    set_meta_tags({
      title: "捐款支持",
      og: {
        title: "捐款支持",
        image: @article.image.blank? ? "#{Setting.url.protocol}://#{Setting.url.host}/images/jrf-img.png" : "#{Setting.url.protocol}://#{Setting.url.host}#{@article.image}"
      },
      article: {
        author: 'https://www.facebook.com/jrf.tw',
        published_time: @article.published_at.strftime('%FT%T%:z'),
        modified_time: @article.updated_at.strftime('%FT%T%:z')
      },
      twitter: {
        image: @article.image.blank? ? "#{Setting.url.protocol}://#{Setting.url.host}/images/jrf-img.png" : "#{Setting.url.protocol}://#{Setting.url.host}#{@article.image}",
      }
    })
  end

  def privacy
    @article = Article.where(kind: 'system', system_type: 'privacy').first
    set_meta_tags({
      title: "隱私條款",
      og: {
        title: "隱私條款",
        image: @article.image.blank? ? "#{Setting.url.protocol}://#{Setting.url.host}/images/jrf-img.png" : "#{Setting.url.protocol}://#{Setting.url.host}#{@article.image}"
      },
      article: {
        author: 'https://www.facebook.com/jrf.tw',
        published_time: @article.published_at.strftime('%FT%T%:z'),
        modified_time: @article.updated_at.strftime('%FT%T%:z')
      },
      twitter: {
        image: @article.image.blank? ? "#{Setting.url.protocol}://#{Setting.url.host}/images/jrf-img.png" : "#{Setting.url.protocol}://#{Setting.url.host}#{@article.image}",
      }
    })
  end

  def thanks
    set_meta_tags({
      title: "感謝您的支持",
      og: {
        title: "感謝您的支持",
        image: "#{Setting.url.protocol}://#{Setting.url.host}/images/thanks.png"
      },
      twitter: {
        image: "#{Setting.url.protocol}://#{Setting.url.host}/images/thanks.png"
      }
    })
  end

  def sitemap
    # 系統頁（關於我們、捐款）有自己的網址，不重複列 /articles/:id
    @articles = Article.published.where.not(kind: 'system')
    @keywords = Keyword.published
    @system_articles = %w(about donate).filter_map do |system_type|
      article = Article.find_by(kind: 'system', system_type: system_type)
      [system_type, article] if article
    end
  end

  def feed
    @articles = Article.published
    respond_to do |format|
      format.atom { render layout: false }
    end
  end

  def instant_articles
    @articles = Article.published
    respond_to do |format|
      format.rss { render layout: false }
    end
  end
end
