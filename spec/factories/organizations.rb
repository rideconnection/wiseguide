# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :case_mgmt_organization, :class => :organization do
    name "My Case Management Organization"
    organization_type Organization::ORGANIZATION_TYPES[:case_mgmt][:id]
    association :parent, :factory => :government_organization
  end

  factory :government_organization, :class => :organization do
    name "My Government Organization"
    organization_type Organization::ORGANIZATION_TYPES[:government][:id]
  end

  factory :parent_organization, :class => :organization do
    name "My Parent Organization"
    organization_type Organization::ORGANIZATION_TYPES[:parent][:id]
  end
end
