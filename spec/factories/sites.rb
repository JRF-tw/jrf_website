FactoryGirl.define do
  factory :site do
    sequence(:title) { |n| "Site #{n}" }
    sequence(:url) { |n| "http://example#{n}.com" }
    sequence(:description) { |n| "Site description #{n}" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'test.jpg')) }
  end
end