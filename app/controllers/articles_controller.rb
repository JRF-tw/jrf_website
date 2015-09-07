class ArticlesController < ApplicationController
  before_action :set_article, except: [:index, :new, :presses, :activities, :comments, :epapers, :books]
  #before_action :authenticate_user!, except: [:show, :index]

  # GET /articles
  def index
    if params[:format] == "json"
      if params[:query]
        @articles = Article.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .published.offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .published.count
      else
        @articles = Article.published.offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.published.count
      end
    else
      if user_signed_in? and current_user.admin?
        @q = Article.search(params[:q])
        @articles = @q.result(:distinct => true).page(params[:page])
      else
        @q = Article.published.search(params[:q])
        @articles = @q.result(:distinct => true).page(params[:page])
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
      format.json { render :json => {
          status: "success",
          articles: JSON.parse(
            @articles.to_json({include: [:keywords], except: [:published]})
          ),
          count: @articles_count
        },
        callback: params[:callback]
      }
    end
  end

  def presses
    if params[:format] == "json"
      if params[:query]
        @articles = Article.presses.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.presses.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .count
      else
        @articles = Article.presses.published.offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.presses.published.count
      end
    else
      if user_signed_in? and current_user.admin?
        @q = Article.presses.search(params[:q])
      else
        @q = Article.presses.published.search(params[:q])
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
      format.json { render :json => {
          status: "success",
          articles: JSON.parse(
            @articles.to_json({include: [:keywords], except: [:published]})
          ),
          count: @articles_count
        },
        callback: params[:callback]
      }
    end
  end

  def activities
    if params[:format] == "json"
      if params[:query]
        @articles = Article.activities.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.activities.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .count
      else
        @articles = Article.activities.published.offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.activities.published.count
      end
    else
      if user_signed_in? and current_user.admin?
        @q = Article.activities.search(params[:q])
      else
        @q = Article.activities.published.search(params[:q])
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
      format.json { render :json => {
          status: "success",
          articles: JSON.parse(
            @articles.to_json({include: [:keywords], except: [:published]})
          ),
          count: @articles_count
        },
        callback: params[:callback]
      }
    end
  end

  def comments
    if params[:format] == "json"
      if params[:query]
        @articles = Article.comments.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.comments.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .count
      else
        @articles = Article.comments.published.offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.comments.published.count
      end
    else
      if user_signed_in? and current_user.admin?
        @q = Article.comments.search(params[:q])
      else
        @q = Article.comments.published.search(params[:q])
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
      format.json { render :json => {
          status: "success",
          articles: JSON.parse(
            @articles.to_json({include: [:keywords], except: [:published]})
          ),
          count: @articles_count
        },
        callback: params[:callback]
      }
    end
  end

  def epapers
    if params[:format] == "json"
      if params[:query]
        @articles = Article.epapers.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.epapers.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .count
      else
        @articles = Article.epapers.published.offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.epapers.published.count
      end
    else
      if user_signed_in? and current_user.admin?
        @q = Article.epapers.search(params[:q])
      else
        @q = Article.epapers.published.search(params[:q])
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
      format.json { render :json => {
          status: "success",
          articles: JSON.parse(
            @articles.to_json({include: [:keywords], except: [:published]})
          ),
          count: @articles_count
        },
        callback: params[:callback]
      }
    end
  end

  def books
    if params[:format] == "json"
      if params[:query]
        @articles = Article.books.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.books.published.ransack({title_or_content_cont: params[:query]}).result(distinct: true)
          .count
      else
        @articles = Article.books.published.offset(params[:offset]).limit(params[:limit])
        @articles_count = Article.books.published.count
      end
    else
      if user_signed_in? and current_user.admin?
        @q = Article.books.search(params[:q])
      else
        @q = Article.books.published.search(params[:q])
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
      format.json { render :json => {
          status: "success",
          articles: JSON.parse(
            @articles.to_json({include: [:keywords], except: [:published]})
          ),
          count: @articles_count
        },
        callback: params[:callback]
      }
    end
  end

  # GET /articles/1
  def show
    unless @article.published
      if user_signed_in? and current_user.admin?
      else
        not_found
      end
    end
    keywords = @article.keywords.to_a.map{ |k| k.name }.join(',')
    if @article.keywords.first
      @articles = @article.keywords.first.articles.first(4).reject { |a| [@article].include? a }
      if @articles.length > 3
        @articles = @articles.first(3)
      end
    else
      @articles = []
    end
    set_meta_tags({
      title: @article.title,
      description: sanitize(@article.description),
      keywords: keywords,
      og: {
        type: 'article',
        image: @article.image.blank? ? "#{Setting.url.protocol}://#{Setting.url.host}/images/jrf-img.png" : "#{Setting.url.protocol}://#{Setting.url.host}#{@article.image}",
        title: @article.title,
        description: sanitize(@article.description)
      }
    })

    respond_to do |format|
      format.html
      format.json { render :json => {
        status: "success",
        article: JSON.parse(
            @article.to_json({include: [:keywords], except: [:published]})
          ),
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
