FactoryGirl.define do
  factory :customer do
    sequence(:last_name) {|n| "Villa #{n}" }
    sequence(:email) {|n| "bob.villa.#{n}@homesweethome.com" }
    
    first_name     'Bob'        
    birth_date     '1930-01-28'
    gender         'M'
    phone_number_1 '123-456-7890'
    address        '123 Good Street Bro'
    city           'Portland'
    state          'OR'
    zip            '12345'
    
    ethnicity
    
    after_build do |o|
      o.county = FactoryGirl.create(:county).name
    end
  end
end
