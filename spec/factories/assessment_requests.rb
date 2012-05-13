FactoryGirl.define do
  factory :assessment_request do
    customer_first_name "MyString"
    customer_last_name "MyString"
    customer_phone "MyString"
    customer_birth_date "2012-01-29"
    notes "MyText"
    association :submitter, :factory => :user
  end
end
