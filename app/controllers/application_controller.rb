class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_catalog, :set_article_q, :set_keywords

  def append_info_to_payload(payload)
    super
    payload[:request_id] = request.uuid
    payload[:user_id] = current_user.id if current_user
    if request.env['HTTP_CF_CONNECTING_IP']
      payload[:ip] = request.env['HTTP_CF_CONNECTING_IP']
    elsif request.env["HTTP_X_FORWARDED_FOR"]
      payload[:ip] = request.env["HTTP_X_FORWARDED_FOR"]
    else
      payload[:ip] = request.env['REMOTE_ADDR']
    end
  end

  private

  def set_catalog
    # Use preload to avoid eager loading detection issues
    @catalogs = Catalog.published.preload(categories: :keywords)
  end

  def set_article_q
    @article_q = Article.includes(:keywords).ransack(params[:q])
  end

  def set_keywords
    @injustice_keyword = Keyword.where(name: '我要申訴').first
    @appeal_keyword = Keyword.where(name: '我要申冤').first
    @recruit_keyword = Keyword.where(name: '徵才訊息').first
  end

  def after_sign_in_path_for(resource)
    if current_user.admin
      request.env['omniauth.origin'] || stored_location_for(resource) || admin_catalogs_path
    else
      sign_out current_user
      root_path
    end
  end

  def sanitize(html)
    Nokogiri::HTML(html).text
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
