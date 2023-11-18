FactoryBot.define do
  factory :user do
    name {"rspec_test_user"}
    email {"rspec_test_user@examle.com"}
    password {"password"}
  end
end
