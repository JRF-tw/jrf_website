FactoryBot.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}_#{rand(1000).to_s}@example.com"}
    password { "P@ssw0rd" }
    password_confirmation { "P@ssw0rd" }
    admin { false }
  end

  factory :admin, class: User do
    sequence(:name)  { |n| "Admin #{n}" }
    sequence(:email) { |n| "Admin_#{n}_#{rand(1000).to_s}@example.com"}
    password { "P@ssw0rd" }
    password_confirmation { "P@ssw0rd" }
    admin { true }
  end
end