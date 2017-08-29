class Api::KeywordsController < ApplicationController
  respond_to :json

  def index
    limit = params[:limit].blank? ? 10 : params[:limit]
    ransack_params = {}
    ransack_params[:title_or_name_cont] = params[:query] if params[:query]
    if ransack_params.blank?
      @keywords = Keyword.includes(category: :catalog).published.offset(params[:offset]).limit(limit)
      @keywords_count = Keyword.published.count
    else
      @keywords = Keyword.includes(category: :catalog).published.ransack(ransack_params).result(distinct: true)
        .offset(params[:offset]).limit(limit)
      @keywords_count = Keyword.published.ransack(ransack_params).result(distinct: true).count
    end
    respond_with(@keywords, @keywords_count)
  end

  def show
    @keyword = Keyword.includes(:articles, { category: :catalog }).find(params[:id])
    if @keyword.published
      respond_with(@keyword)
    else
      not_found
    end
  end
end