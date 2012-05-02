FactoryGirl.define do
  factory :funding_source do
    sequence(:name) {|n| "Funding Source #{n}" }
  end
end
