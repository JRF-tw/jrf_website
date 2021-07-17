class Admin::BaseController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :require_admin, :set_articles

  private

  def require_admin
    unless current_user.admin?
      sign_out current_user
      redirect_to '/'
    end
  end

  def set_articles
    @about_article = Article.where(kind: 'system', system_type: 'about').first
    @donate_article = Article.where(kind: 'system', system_type: 'donate').first
    @privacy_article = Article.where(kind: 'system', system_type: 'privacy').first
  end

end