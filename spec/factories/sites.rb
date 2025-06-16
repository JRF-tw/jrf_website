FactoryBot.define do
  factory :site do
    sequence(:title) { |n| "Site #{n}" }
    sequence(:link) { |n| "http://example#{n}.com" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'test.jpg')) }
    published { true }
  end
end