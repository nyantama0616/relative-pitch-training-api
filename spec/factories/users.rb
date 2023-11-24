FactoryBot.define do
  factory :user do
    sequence(:user_name) {|i| "rspec_test_user#{i}"}
    sequence(:email) {|i| "rspec_test_user#{i}@examle.com"}
    password {"password"}
  end
end
