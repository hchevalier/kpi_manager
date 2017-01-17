FactoryGirl.define do
  factory :user do
    firstname Faker::Name.first_name
    lastname Faker::Name.last_name
    email Faker::Internet.email
    birthdate Faker::Date.between(20.years.ago, 10.years.ago)
    created_at Faker::Date.between(2.hours.ago, 10.minutes.ago)
  end
end
