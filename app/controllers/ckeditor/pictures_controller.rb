class Ckeditor::PicturesController < Ckeditor::ApplicationController
  protect_from_forgery with: :null_session, only: [:create]
  skip_before_action :set_catalog, :set_article_q, :set_keywords
end
