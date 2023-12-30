FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "test_user#{i}"}
    sequence(:email) { |i| "test_user#{i}@examle.com"}
    password {"password"}
  end
end
