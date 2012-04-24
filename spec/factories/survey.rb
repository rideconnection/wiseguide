FactoryGirl.define do
  factory :survey do |f|
    f.sequence(:title) {|n| "Survey #{n}" }
    f.active_at Date.current
    f.inactive_at nil
  end
end
