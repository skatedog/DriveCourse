FactoryBot.define do
  factory :user do
    email {"sample@example.com"}
    name {"user-name"}
    introduction {"user-introduction"}
    password {"password"}
    password_confirmation {"password"}
  end
end