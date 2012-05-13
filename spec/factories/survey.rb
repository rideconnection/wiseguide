FactoryGirl.define do
  factory :survey do
    sequence(:title) {|n| "Survey #{n}" }
    active_at Date.current
    inactive_at nil
  end
end
