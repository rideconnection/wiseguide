# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :resource do
    name "MyString"
    phone_number "MyString"
    email "MyString"
    url "MyString"
    address "MyText"
    hours "MyText"
    notes "MyText"
  end
end
