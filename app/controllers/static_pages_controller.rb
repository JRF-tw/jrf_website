class StaticPagesController < ApplicationController
  def home
    @keywords = Keyword.showed
    @articles = Article.includes(:keywords).published.page(params[:page]).per(6)
    @epaper_article = Article.epapers.first
    @book_articles = Article.books.first(6)
  end

  def search
    q = params[:q]
    @articles = Article.published.search(title_or_content_cont: q).result.page(params[:page])
    # @videos = Video.published.search(title_or_content_cont: q).result.page(params[:videos_page])
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
    @articles = Article.published
    @keywords = Keyword.published
  end

  def feed
    @articles = Article.published
    respond_to do |format|
      format.atom { render :layout => false }
    end
  end

  def instant_articles
    @articles = Article.published
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end
end
