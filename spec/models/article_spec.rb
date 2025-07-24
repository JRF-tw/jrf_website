require "rails_helper"

describe Article do
  it "#factory_creat_press_success" do
    expect {
      FactoryBot.create :press_article
    }.to change { Article.count }.by(1)
  end

  it "#factory_creat_activity_success" do
    expect {
      FactoryBot.create :activity_article
    }.to change { Article.count }.by(1)
  end

  it "#factory_creat_comment_success" do
    expect {
      FactoryBot.create :comment_article
    }.to change { Article.count }.by(1)
  end

  it "published work" do
    article1 = FactoryBot.create(:press_article)
    article2 = FactoryBot.create(:press_article, published: false)
    article3 = FactoryBot.create(:press_article, published_at: 1.day.from_now)
    expect(Article.published).to eq([article3, article1])
  end

  it "presses, activities, comments work" do
    article1 = FactoryBot.create(:press_article, published_at: 1.day.ago)
    article2 = FactoryBot.create(:press_article, published_at: 2.days.ago)
    article3 = FactoryBot.create(:activity_article, published_at: 3.days.ago)
    article4 = FactoryBot.create(:activity_article, published_at: 4.days.ago)
    article5 = FactoryBot.create(:comment_article, published_at: 5.days.ago)
    article6 = FactoryBot.create(:comment_article, published_at: 6.days.ago)
    article7 = FactoryBot.create(:epaper_article, published_at: 7.days.ago)
    article8 = FactoryBot.create(:epaper_article, published_at: 8.days.ago)
    article9 = FactoryBot.create(:book_article, published_at: 9.days.ago)
    article10 = FactoryBot.create(:book_article, published_at: 10.days.ago)
    expect(Article.presses).to eq([article1, article2])
    expect(Article.activities).to eq([article3, article4])
    expect(Article.comments).to eq([article5, article6])
    expect(Article.epapers).to eq([article7, article8])
    expect(Article.books).to eq([article9, article10])
  end

  it "#youtube_update_work" do
    article = FactoryBot.build(:press_article)
    article.youtube_url = 'https://www.youtube.com/watch?v=Gh1zJVwHhjw'
    article.update_youtube_values
    expect(article.youtube_id).to eq("Gh1zJVwHhjw")
  end

  it "should extract youtube list id" do
    article = FactoryBot.build(:press_article)
    article.youtube_url = 'https://www.youtube.com/watch?v=Gh1zJVwHhjw&list=PLtest123'
    article.update_youtube_values
    expect(article.youtube_id).to eq("Gh1zJVwHhjw")
    expect(article.youtube_list_id).to eq("PLtest123")
  end

  it "should handle invalid youtube url" do
    article = FactoryBot.build(:press_article)
    article.youtube_url = 'https://invalid-url.com'
    expect(article.save).to be_falsey
    expect(article.errors[:base]).to include('youtube網址錯誤')
  end

  it "should validate content presence for non-system articles" do
    article = FactoryBot.build(:press_article, content: '')
    expect(article).not_to be_valid
    expect(article.errors[:content]).to include('內容不能為空')
  end

  it "should allow empty content for system articles" do
    article = FactoryBot.build(:article, kind: 'system', content: '')
    expect(article).to be_valid
  end

  it "should require published_at" do
    article = FactoryBot.build(:press_article, published_at: nil)
    expect(article).not_to be_valid
    expect(article.errors[:published_at]).to be_present
  end

  it "should have youtube_embed_url method" do
    article = FactoryBot.create(:press_article)
    article.youtube_id = 'test123'
    expect(article.youtube_embed_url).to include('test123')
  end

  it "should process fb_ia_content before save" do
    article = FactoryBot.build(:press_article)
    article.content = '<p>Test content</p>'
    article.save
    expect(article.fb_ia_content).to be_present
  end

  it "should belong to user" do
    article = FactoryBot.create(:press_article)
    expect(article.user).to be_present
  end

  it "should have slides association" do
    article = FactoryBot.create(:press_article)
    expect(article).to respond_to(:slides)
  end
end
