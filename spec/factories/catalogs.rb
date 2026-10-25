FactoryBot.define do
  factory :catalog do
    sequence(:name) { |n| "Catalog #{n}" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'test.jpg'), 'image/jpeg') }
    published { true }
  end
end