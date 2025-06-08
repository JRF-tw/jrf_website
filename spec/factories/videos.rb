FactoryGirl.define do
  factory :video do
    sequence(:title) { |n| "Video #{n}" }
    sequence(:content) { |n| "Video content #{n}" }
    sequence(:author) { |n| "Video author #{n}" }
    sequence(:published_at) { |n| n.days.ago }
    user
    published true
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'test.jpg')) }
  end
end