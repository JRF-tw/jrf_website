FactoryBot.define do
  factory :category do
    sequence(:name)  { |n| "Category #{n}" }
    catalog { FactoryBot.create(:catalog) }
    published { true }
  end
end
