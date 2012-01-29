# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :assessment_request do
    customer_first_name "MyString"
    customer_last_name "MyString"
    customer_phone "MyString"
    customer_birth_date "2012-01-29"
    notes "MyText"
    submitter_id 1
  end
end
