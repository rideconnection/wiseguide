FactoryGirl.define do
  factory :customer do |f|
    f.sequence(:last_name) {|n| "Villa #{n}" }
    f.sequence(:email) {|n| "bob.villa.#{n}@homesweethome.com" }
    
    f.first_name     'Bob'        
    f.birth_date     '1930-01-28'
    f.gender         'M'
    f.phone_number_1 '123-456-7890'
    f.address        '123 Good Street Bro'
    f.city           'Portland'
    f.state          'OR'
    f.zip            '12345'
    
    f.association :ethnicity
    
    f.after_build do |o|
      o.county = FactoryGirl.create(:county).name
    end
  end
end
