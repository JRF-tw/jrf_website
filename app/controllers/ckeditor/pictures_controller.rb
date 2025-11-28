class Ckeditor::PicturesController < Ckeditor::ApplicationController
  protect_from_forgery except: :create
  skip_before_action :set_catalog, :set_article_q, :set_keywords

  # Log to verify this custom controller is loaded
  Rails.logger.info "=== Custom Ckeditor::PicturesController loaded ==="

  def create
    Rails.logger.info "=== Ckeditor::PicturesController#create called ==="
    Rails.logger.info "Request method: #{request.method}"
    Rails.logger.info "Request format: #{request.format}"
    Rails.logger.info "CSRF token from params: #{params[:authenticity_token].present? ? 'present' : 'missing'}"
    Rails.logger.info "CSRF token from headers: #{request.headers['X-CSRF-Token'].present? ? 'present' : 'missing'}"
    Rails.logger.info "Session ID: #{session.id}" if session.id
    Rails.logger.info "Current user: #{current_user.inspect}" if respond_to?(:current_user)

    super
  end
end
