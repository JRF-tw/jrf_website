FactoryBot.define do
  factory :article do
    sequence(:title)  { |n| "Article title #{n}" }
    sequence(:content)  { |n| "Article content #{n}" }
    sequence(:description)  { |n| "Article description #{n}" }
    sequence(:author)  { |n| "Article author #{n}" }
    sequence(:published_at) { |n| n.days.ago }
    keywords {[ FactoryBot.create(:keyword) ]}
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'test.jpg')) }
    published { true }
    user
  end

  factory :press_article, parent: :article do
    kind { "press" }
  end

  factory :activity_article, parent: :article do
    kind { "activity" }
  end

  factory :comment_article, parent: :article do
    kind { "comment" }
  end

  factory :epaper_article, parent: :article do
    kind { "epaper" }
  end

  factory :book_article, parent: :article do
    kind { "book" }
  end

  factory :about_article, parent: :article do
    kind { "system" }
    id { 1 }
    system_type { 'about' }
  end

  factory :donate_article, parent: :article do
    kind { "system" }
    id { 2 }
    system_type { 'donate' }
  end
end



