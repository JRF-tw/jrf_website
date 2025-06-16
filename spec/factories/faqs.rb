FactoryBot.define do
  factory :faq do
    keyword { FactoryBot.create(:keyword) }
    sequence(:question) { |n| "Faq question #{n}" }
    sequence(:answer) { |n| "Faq answer #{n}" }
  end
end
