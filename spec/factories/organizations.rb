FactoryGirl.define do
  factory :organization, :aliases => [:staff_organization] do
    name "My Staff Organization"
    organization_type Organization::ORGANIZATION_TYPES[:staff][:id]

    factory :case_mgmt_organization, :aliases => [:case_management_organization] do
      name "My Case Management Organization"
      organization_type Organization::ORGANIZATION_TYPES[:case_mgmt][:id]
      association :parent, :factory => :government_organization
    end
  
    factory :government_organization do
      name "My Government Organization"
      organization_type Organization::ORGANIZATION_TYPES[:government][:id]
    end
  end
end
