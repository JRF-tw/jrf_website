class Ckeditor::PicturesController < Ckeditor::ApplicationController
  protect_from_forgery except: :create
  skip_before_action :set_catalog, :set_article_q, :set_keywords
end
