FactoryGirl.define do
  factory :survey do
    sequence(:title) {|n| "Survey #{n}" }
    display_order 0
    active_at Date.current
    inactive_at nil
  end
end
