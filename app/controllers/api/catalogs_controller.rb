class Api::CatalogsController < ApplicationController
  respond_to :json

  def index
    limit = params[:limit].blank? ? 10 : params[:limit]
    ransack_params = {}
    ransack_params[:name_cont] = params[:query] if params[:query]
    if ransack_params.blank?
      @catalogs = Catalog.includes(categories: :keywords).published.offset(params[:offset]).limit(limit)
      @catalogs_count = Catalog.published.count
    else
      @catalogs = Catalog.includes(categories: :keywords).ransack(ransack_params).result(distinct: true)
        .published.offset(params[:offset]).limit(limit)
      @catalogs_count = Catalog.ransack(ransack_params).result(distinct: true).published.count
    end
    respond_with(@catalogs, @catalogs_count)
  end

  def show
    @catalog = Catalog.includes(categories: :keywords).find(params[:id])
    respond_with(@catalog)
  end
end