class ArticlesController < ApplicationController
  before_action :set_article, except: [:index, :presses, :activities, :comments, :epapers, :books]
  #before_action :authenticate_user!, except: [:show, :index]

  # GET /articles
  def index
    if params[:format] == "json"
      if params[:query]
        @articles = Article.includes(:keywords).published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .published.offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.includes(:keywords).published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .published.count
      else
        @articles = Article.includes(:keywords).published.offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.includes(:keywords).published.count
      end
    else
      if user_signed_in? and current_user.admin?
        @q = Article.includes(:keywords).ransack(params[:q])
        @articles = @q.result(distinct: true).page(params[:page])
      else
        @q = Article.includes(:keywords).published.ransack(params[:q])
        @articles = @q.result(distinct: true).page(params[:page])
      end
    end
    set_meta_tags({
      title: "所有文章",
      og: {
        title: "所有文章"
      }
    })

    respond_to do |format|
      format.html
      format.json { render json: {
        status: "success",
        articles: @articles.as_json(include: [:keywords], except: [:published]),
        count: @articles_count
      },
      callback: params[:callback]
      }
    end
  end

  def presses
    if params[:format] == "json"
      if params[:query]
        @articles = Article.includes(:keywords).presses.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.includes(:keywords).presses.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .count
      else
        @articles = Article.includes(:keywords).presses.published.offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.includes(:keywords).presses.published.count
      end
    else
      if user_signed_in? and current_user.admin?
        @q = Article.includes(:keywords).presses.ransack(params[:q])
      else
        @q = Article.includes(:keywords).presses.published.ransack(params[:q])
      end
      @articles = @q.result(distinct: true).page(params[:page])
    end
    set_meta_tags({
      title: "新聞稿",
      og: {
        title: "新聞稿"
      }
    })
    respond_to do |format|
      format.html
      format.json { render json: {
        status: "success",
        articles: @articles.as_json(include: [:keywords], except: [:published]),
        count: @articles_count
      },
      callback: params[:callback]
      }
    end
  end

  def activities
    if params[:format] == "json"
      if params[:query]
        @articles = Article.includes(:keywords).activities.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.includes(:keywords).activities.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .count
      else
        @articles = Article.includes(:keywords).activities.published.offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.includes(:keywords).activities.published.count
      end
    else
      if user_signed_in? and current_user.admin?
        @q = Article.includes(:keywords).activities.ransack(params[:q])
      else
        @q = Article.includes(:keywords).activities.published.ransack(params[:q])
      end
      @articles = @q.result(distinct: true).page(params[:page])
    end
    set_meta_tags({
      title: "最新活動",
      og: {
        title: "最新活動"
      }
    })
    respond_to do |format|
      format.html
      format.json { render json: {
        status: "success",
        articles: @articles.to_json(include: [:keywords], except: [:published]),
        count: @articles_count
      },
      callback: params[:callback]
      }
    end
  end

  def comments
    if params[:format] == "json"
      if params[:query]
        @articles = Article.includes(:keywords).comments.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.includes(:keywords).comments.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .count
      else
        @articles = Article.includes(:keywords).comments.published.offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.includes(:keywords).comments.published.count
      end
    else
      if user_signed_in? and current_user.admin?
        @q = Article.includes(:keywords).comments.ransack(params[:q])
      else
        @q = Article.includes(:keywords).comments.published.ransack(params[:q])
      end
      @articles = @q.result(distinct: true).page(params[:page])
    end
    set_meta_tags({
      title: "評論文章",
      og: {
        title: "評論文章"
      }
    })
    respond_to do |format|
      format.html
      format.json { render json: {
        status: "success",
        articles: @articles.as_json(include: [:keywords], except: [:published]),
        count: @articles_count
      },
      callback: params[:callback]
      }
    end
  end

  def epapers
    if params[:format] == "json"
      if params[:query]
        @articles = Article.includes(:keywords).epapers.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.includes(:keywords).epapers.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .count
      else
        @articles = Article.includes(:keywords).epapers.published.offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.includes(:keywords).epapers.published.count
      end
    else
      if user_signed_in? and current_user.admin?
        @q = Article.includes(:keywords).epapers.ransack(params[:q])
      else
        @q = Article.includes(:keywords).epapers.published.ransack(params[:q])
      end
      @articles = @q.result(distinct: true).page(params[:page])
    end
    set_meta_tags({
      title: "電子報",
      og: {
        title: "電子報"
      }
    })
    respond_to do |format|
      format.html
      format.json { render json: {
        status: "success",
        articles: @articles.as_json(include: [:keywords], except: [:published]),
        count: @articles_count
      },
      callback: params[:callback]
      }
    end
  end

  def books
    if params[:format] == "json"
      if params[:query]
        @articles = Article.includes(:keywords).books.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.includes(:keywords).books.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .count
      else
        @articles = Article.includes(:keywords).books.published.offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.includes(:keywords).books.published.count
      end
    else
      if user_signed_in? and current_user.admin?
        @q = Article.includes(:keywords).books.ransack(params[:q])
      else
        @q = Article.includes(:keywords).books.published.ransack(params[:q])
      end
      @articles = @q.result(distinct: true).page(params[:page])
    end
    set_meta_tags({
      title: "出版品",
      og: {
        title: "出版品"
      }
    })
    respond_to do |format|
      format.html
      format.json { render json: {
        status: "success",
        articles: @articles.as_json(include: [:keywords], except: [:published]),
        count: @articles_count
      },
      callback: params[:callback]
      }
    end
  end

  # GET /articles/1
  def show
    keywords = @article.keywords.to_a.map{ |k| k.name }.join(',')
    if @article.keywords.first
      @related_articles = @article.keywords.first.articles.published.first(4).reject { |a| [@article].include? a }
      if @related_articles.length > 3
        @related_articles = @related_articles.first(3)
      end
    else
      @related_articles = []
    end
    @lastest_articles = Article.published.first(3)
    set_meta_tags({
      title: @article.title,
      description: sanitize(@article.description),
      keywords: keywords,
      og: {
        type: 'article',
        image: @article.image.blank? ? "#{Setting.url.protocol}://#{Setting.url.host}/images/jrf-img.png" : "#{Setting.url.protocol}://#{Setting.url.host}#{@article.image}",
        title: @article.title,
        description: sanitize(@article.description)
      },
      article: {
        author: Setting.url.fb,
        publisher: Setting.url.fb,
        published_time: @article.published_at.strftime('%FT%T%:z'),
        modified_time: @article.updated_at.strftime('%FT%T%:z')
      },
      twitter: {
        image: @article.image.blank? ? "#{Setting.url.protocol}://#{Setting.url.host}/images/jrf-img.png" : "#{Setting.url.protocol}://#{Setting.url.host}#{@article.image}",
      }
    })

    respond_to do |format|
      format.html
      format.json { render json: {
        status: "success",
        article: @article.as_json(include: [:keywords], except: [:published]),
        callback: params[:callback]
        }
      }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = params[:id] ? Article.find(params[:id]) : Article.new(article_params)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def article_params
    params.require(:article).permit()
  end
end
