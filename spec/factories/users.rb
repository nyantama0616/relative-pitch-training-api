FactoryBot.define do
  factory :user do
    sequence(:name) {|i| "rspec_test_user#{i}"}
    sequence(:email) {|i| "rspec_test_user#{i}@examle.com"}
    password {"password"}
  end
end
