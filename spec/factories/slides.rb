FactoryBot.define do

  factory :article_slide, class: "Slide" do
    association :slideable, factory: :article
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'test.jpg')) }
  end

  factory :keyword_slide, class: "Slide" do
    association :slideable, factory: :keyword
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'test.jpg')) }
  end
end
