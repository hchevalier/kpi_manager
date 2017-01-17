FactoryGirl.define do
  factory :car do
    brand Faker::Vehicle.manufacture
    model Faker::Commerce.product_name
    price Faker::Commerce.price
  end
end
