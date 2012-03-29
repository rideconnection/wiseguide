# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :case_mgmt_organization, :class => :organization do
    name "My Case Management Organization"
    organization_type Organization::ORGANIZATION_TYPES[:case_mgmt][:id]
    association :parent, :factory => :government_organization
  end
  factory :case_management_organization, :parent => :case_mgmt_organization do; end
  
  factory :government_organization, :class => :organization do
    name "My Government Organization"
    organization_type Organization::ORGANIZATION_TYPES[:government][:id]
  end

  factory :staff_organization, :class => :organization do
    name "My Staff Organization"
    organization_type Organization::ORGANIZATION_TYPES[:staff][:id]
  end
  factory :organization, :parent => :staff_organization do; end
end
