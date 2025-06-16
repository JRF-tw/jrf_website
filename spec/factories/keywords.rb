FactoryBot.define do
  factory :keyword do
    sequence(:name)  { |n| "Keyword #{n}" }
    sequence(:title)  { |n| "Keyword title #{n}" }
    sequence(:content)  { |n| "Keyword content #{n}" }
    sequence(:description)  { |n| "Keyword description #{n}" }
    category { FactoryBot.create(:category) }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'test.jpg')) }
    cover { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'test.jpg')) }
    published { true }
  end
end