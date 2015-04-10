class StaticPagesController < ApplicationController
  def home
    @keywords = Keyword.showed
    @articles = Article.all.page(params[:page]).per(10)
    @magazine_article = MagazineArticle.first
  end

  def search
    q = params[:q]
    @articles = Article.published.search(title_or_content_cont: q).result.page(params[:articles_page])
    @videos = Video.published.search(title_or_content_cont: q).result.page(params[:videos_page])
    @kinds = []
    @articles.each do |a|
      unless @kinds.include? a.kind
        @kinds << a.kind if a.kind
      end
    end
    puts @kinds
  end

  def about
  end

  def donate
  end
end
