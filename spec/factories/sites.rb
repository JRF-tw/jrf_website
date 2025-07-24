FactoryBot.define do
  factory :site do
    sequence(:title) { |n| "Site #{n}" }
    sequence(:link) { |n| "http://example#{n}.com" }
    published { true }
  end
end