class ErrorsController < ApplicationController
  # Set required variables for HTML error pages only
  before_action :set_variables_for_html, if: -> { request.format.html? }

  def error404
    @keyword = Keyword.where(name: '反黑箱服貿案').first
    respond_to do |format|
      format.html { render status: :not_found }
      format.json { render json: {error: "not found", status: "failed"}, status: :not_found, callback: params[:callback] }
      format.any { render status: :not_found, formats: [:html] }
    end
  end

  def error422
    respond_to do |format|
      format.html { render status: :unprocessable_entity }
      format.json { render json: {error: "unprocessable entity", status: "failed"}, status: :unprocessable_entity, callback: params[:callback] }
      format.any { render status: :unprocessable_entity, formats: [:html] }
    end
  end

  def error500
    @keyword = Keyword.where(name: '邱和順案').first
    respond_to do |format|
      format.html { render status: :internal_server_error }
      format.json { render json: {error: "internal server error", status: "failed"}, status: :internal_server_error, callback: params[:callback] }
      format.any { render status: :internal_server_error, formats: [:html] }
    end
  end

  private

  def set_variables_for_html
    set_catalog
    set_article_q
    set_keywords
  end
end