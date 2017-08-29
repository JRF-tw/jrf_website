class Api::ArticlesController < ApplicationController
  respond_to :json

  def index
    limit = params[:limit].blank? ? 10 : params[:limit]
    ransack_params = {}
    ransack_params[:kind_eq] = params[:kind] if params[:kind]
    ransack_params[:title_or_content_or_author_cont] = params[:query] if params[:query]
    ransack_params[:published_at_gt] = params[:date_start] if params[:date_start]
    ransack_params[:published_at_lt] = params[:date_end] if params[:date_end]
    if ransack_params.blank?
      @articles = Article.includes(:keywords).offset(params[:offset]).limit(limit)
      @articles_count = Article.count
    else
      @articles = Article.includes(:keywords).ransack(ransack_params).result(distinct: true)
        .offset(params[:offset]).limit(limit)
      @articles_count = Article.ransack(ransack_params).result(distinct: true).count
    end
    respond_with(@articles, @articles_count)
  end

  def show
    @article = Article.includes(:keywords).find(params[:id])
    respond_with(@article)
  end
end