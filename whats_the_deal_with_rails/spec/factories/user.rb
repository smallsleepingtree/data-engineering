FactoryGirl.define do
  factory :user do
    email 'me@example.com'
    password 'password'

    factory :authorized_user do
      authorized true
    end
  end
end