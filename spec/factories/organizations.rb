# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name "My Organization"
    organization_type_id 1
    parent_id 0
  end
end
