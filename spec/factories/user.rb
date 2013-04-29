FactoryGirl.define do
  factory :user do
    email 'me@example.com'
    password 'password'

    factory :authorized_user do
      authorized true

      factory :admin_user do
        email 'admin@example.com'
        admin true
      end
    end
  end
end