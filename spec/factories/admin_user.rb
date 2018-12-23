FactoryBot.define do
  factory :admin_user do
    sequence(:name) { |n| "テスト##{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }
  end
end
